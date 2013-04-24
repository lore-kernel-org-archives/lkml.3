Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3DXFM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 01:12:28 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:42510 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3DXFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 01:12:27 -0400
Message-ID: <517769A9.5060308@ahsoftware.de>
Date: Wed, 24 Apr 2013 07:12:09 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org>
In-Reply-To: <51774F44.2060704@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 24.04.2013 05:19, schrieb John Stultz:

> On x86 the persistent_clock() is backed by the
> CMOS/EFI/kvm-wall/xen/vrtc clock (all via x86_platform.get_wallclock)
> should be present and we'll initialize the time in timekeeping_init()
> there.
>
> Its only systems where there isn't a persistent_clock is where the RTC
> layer and the HCTOSYS is helpful.

I'm a bit confused too. ;)

Doesn't this remove the users choice of RTC on x86 systems?

Why is there a difference made between the CMOS/EFI/... clocks and other 
RTCs?

And why is RTC_SYSTOHC now gone on x86?

Regards,

Alexander
