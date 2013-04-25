Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3DYHLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:11:37 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45339 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3DYHLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:11:36 -0400
Message-ID: <5178D719.2060405@ahsoftware.de>
Date: Thu, 25 Apr 2013 09:11:21 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de> <51780348.6090202@linaro.org>
In-Reply-To: <51780348.6090202@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2013 18:07, schrieb John Stultz:

>> And why is RTC_SYSTOHC now gone on x86?
>
> So summarizing the above, because as much as I'm aware, its always been
> redundant and unnecessary on x86.  Thus being able at build time to mark
> it as unnecessary was attractive, since it reduced the code paths
> running at suspend/resume.

Hmm, I thought RTC_SYSTOHC was there to update the used RTC clock with 
the time from NTP (and liked that). Therefor I don't understand why it 
is redundant and unnecessary on x86. Of course, most systems do have 
something in userspace to set the RTC on shutdown, so it isn't really 
needed.

Anyway, thanks a lot for the great overview. I was totally unaware about 
the persistent_clock framework on x86.

Regards,

Alexander

