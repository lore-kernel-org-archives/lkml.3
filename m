Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaB0LNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:13:33 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49670 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaB0LNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:13:30 -0500
MIME-Version: 1.0
In-Reply-To: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com>
References: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 27 Feb 2014 12:13:09 +0100
Message-ID: <CAPXgP112sBy+ErD3xYK8=+0tfXPY80wb8Zco5cJKuKkv7+ZViA@mail.gmail.com>
Subject: Re: [PATCH] tty: Add sysfs symlink for console name->tty device
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Ray Strode <halfline@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 3:40 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> Enable a user-space process to discover the underlying tty device
> for a console, if one exists, and when the tty device is later
> created or destroyed.
>
> Add sysfs symlinks for registered consoles to their respective
> devices in [sys/class,sys/devices/virtual]/tty/console.
> Scan consoles at tty device (un)registration to handle deferred
> console<->device (un)binding.

What tool is supposed to read that? I can't think of anything
interested in this, as soon as we have fixed the "active" console
output.

Thanks,
Kay
