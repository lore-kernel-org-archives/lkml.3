Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaF2GYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 02:24:54 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:41573 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaF2GYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 02:24:53 -0400
MIME-Version: 1.0
From: "Gideon D'souza" <gidisrael@gmail.com>
Date: Sun, 29 Jun 2014 11:54:32 +0530
Message-ID: <CAPNrq4xV+LiOhbMhBfHFuf68E1D7XCq87EJuTq0n88UMGdcg4g@mail.gmail.com>
Subject: How is an OS bound to the Linux kernel
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hey guys,

I generally manage to understand the various pieces of the linux
kernel and what their functions are.

However, one thing I don't fully understand is how is any OS, say
fedora (which is what I use) is bound to the kernel.

Lets say I want to just build a system on top of linux that boots and
keeps printing hello world to the screen. When the user presses a key
it exits.

How would I begin to do this? What should I read or look at?

I'm guessing it's a two part thing right, one I need to somehow tell
the kernel what to do after booting, and second I'll have to tell the
kernel what the screen is ? Where would I find more information about
this?

Note: I actually want to make the program I described so tips on how
to play with grub to get the whole thing to work would also be
helpful.

Regards,
Gideon
