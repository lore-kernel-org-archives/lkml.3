Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab3BMPFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:05:11 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:44842 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3BMPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:05:09 -0500
MIME-Version: 1.0
In-Reply-To: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 13 Feb 2013 15:57:02 +0100
Message-ID: <CAH9NwWfSQKW2c1LvLQkojPiKA_r7+_6OmgoVHrBNRHUEFNYvJg@mail.gmail.com>
Subject: Re: [PATCH] Congatec CGEB base, i2c and watchdog driver support
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/12 Sascha Hauer <s.hauer@pengutronix.de>:
> I'd like to come back to this topic. I have sent patches last year
> already, changes to the last time I posted this is mainly that
> I moved the CGEB base support from drivers/mfd/ to arch/x86/platform/
> like suggested by Samuel Ortiz back then.
>
> The following series adds support for the Congatec CGEB interface
> found on some Congatec x86 boards. The CGEB interface is a BIOS
> interface which provides access to onboard peripherals like I2C
> busses and watchdogs. It works by mapping BIOS code and searching
> for magic values which specify the entry points to the CGEB call.
> The CGEB call is an API provided by the BIOS which provides access
> to the functions in an ioctl like fashion.
>
> For more information about the CGEB API have a look at:
>
> http://www.congatec.com/single_news+M5d58c9cd155.html
>
> This document only describes the C API, unfortunately not the
> underlying BIOS interface.
>
> Also added are two users of this interface, a i2c master driver
> and a watchdog driver.
>
> Comments very appreciated.

Hi Sascha,

against what version is this patch set? Would like to try it out but it fails
to apply to 3.8-rc7.

--
Christian Gmeiner, MSc
