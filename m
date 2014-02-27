Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaB0Nb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:31:59 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49128 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751296AbaB0Nb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:31:57 -0500
Message-ID: <530F3E47.5040904@hurleysoftware.com>
Date: Thu, 27 Feb 2014 08:31:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Ray Strode <halfline@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>
Subject: Re: [PATCH] tty: Add sysfs symlink for console name->tty device
References: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com> <CAPXgP112sBy+ErD3xYK8=+0tfXPY80wb8Zco5cJKuKkv7+ZViA@mail.gmail.com>
In-Reply-To: <CAPXgP112sBy+ErD3xYK8=+0tfXPY80wb8Zco5cJKuKkv7+ZViA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 06:13 AM, Kay Sievers wrote:
> On Wed, Feb 26, 2014 at 3:40 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> Enable a user-space process to discover the underlying tty device
>> for a console, if one exists, and when the tty device is later
>> created or destroyed.
>>
>> Add sysfs symlinks for registered consoles to their respective
>> devices in [sys/class,sys/devices/virtual]/tty/console.
>> Scan consoles at tty device (un)registration to handle deferred
>> console<->device (un)binding.
>
> What tool is supposed to read that? I can't think of anything
> interested in this, as soon as we have fixed the "active" console
> output.

Kay,

With all due respect, that "fix" is a ridiculous hack, being done
for self-serving expedience. It already caused one user-space breakage
which you did not expect.

This sysfs interface is superior in every way.

Regards,
Peter Hurley

