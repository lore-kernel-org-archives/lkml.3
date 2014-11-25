Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKYTNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:13:16 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47277 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaKYTNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:13:13 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
References: <20141124210809.GG2817@atomide.com>
	<1416867655-22232-1-git-send-email-al.kochet@gmail.com>
	<20141125141924.GD1843@katana>
	<7E0A0B24-91D5-41A4-B007-004C5965D0D7@gmail.com>
Date: Tue, 25 Nov 2014 11:13:10 -0800
In-Reply-To: <7E0A0B24-91D5-41A4-B007-004C5965D0D7@gmail.com> (Alexander
	Kochetkov's message of "Tue, 25 Nov 2014 17:38:23 +0300")
Message-ID: <7hvbm3jdq1.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kochetkov <al.kochet@gmail.com> writes:

> 25 нояб. 2014 г., в 17:19, Wolfram Sang <wsa@the-dreams.de> написал(а):
>
>> I'll push out this evening to make the boot tests work again. If there
>> is more to be investigated, either hurry up and post v3 ;) or let me
>> know that you need more time.
>
> Ok, thank you. Let the fix go to the kernel-next.
> Maybe small fix to subject "omap: i2c:" to "i2c: omap:"
>
> I still guessing what some boards have broken i2c pull-ups.
> And real fix must go in the board file.
> http://www.spinics.net/lists/linux-i2c/msg17750.html
>
> I could create a patch to confirm this.
> But I don't have omap3530 boards to run.
> I'll be very appreciated if someone could run the patch.

I'll test your patch on all my OMAP boards.  Put whatever debug output
you want, and I'll send you links to all the boot output.

Kevin

