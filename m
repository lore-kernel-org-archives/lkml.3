Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3ANPML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:12:11 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49860 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab3ANPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:12:10 -0500
Subject: watchdog code
From: anish kumar <anish198519851985@gmail.com>
To: johlstei@codeaurora.org
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <m1mxa2cfkq.fsf@fess.ebiederm.org>
References: <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
	 <m1mxa2cfkq.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jan 2013 20:41:59 +0530
Message-ID: <1358176319.1621.11.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From your comments in this thread https://lkml.org/lkml/2011/3/25/723 

>The msm watchdog driver is present in kernel only. It does not use the
>built-in Linux watchdog api. This is because the primary function of
>our watchdog is detecting bus lockups and interrupts being turned off
Doesn't linux original implementation(kernel/watchdog.c) already cover
this?If not then how does this implementation detect it i.e. bus lockup
and interrupt turned off for long time?
Does this piece of code can co-exist with the soft/hard lockup detection
in the core kernel?
>for long periods of time. We wanted this functionality to be present
>regardless of the userspace the kernel is running beneath. Userspace is
>free to have its own watchdog implemented in software.
what does this mean, can you elaborate?

>Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
In my personal opinion, we should always acknowledge the code from which
this code is inspired :)

