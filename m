Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbbANO4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:56:17 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52974 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbANO4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:56:16 -0500
MIME-Version: 1.0
In-Reply-To: <20150113171904.6b2327d5@linux.lan.towertech.it>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-4-git-send-email-xlpang@126.com>
	<20150113171904.6b2327d5@linux.lan.towertech.it>
Date: Wed, 14 Jan 2015 22:56:15 +0800
Message-ID: <CADcy93WPZCmPLUsa9kmz6GtD7E3+8td1PJteJxnZi0R2mLAYKw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/9] rtc/test: Update driver to address y2038/y2106 issues
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Xunlei Pang <xlpang@126.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 00:19, Alessandro Zummo <a.zummo@towertech.it> wrote:
> On Tue, 13 Jan 2015 23:44:51 +0800
> Xunlei Pang <xlpang@126.com> wrote:
>
>> This patch resolves them by:
>> - Repalce get_seconds() with get_seconds64()
>> - Replace rtc_time_to_tm() with rtc_time64_to_tm()
>> - Change test_rtc_set_mmss() to use rtc_class_ops's set_mmss64()
>
>  so we no more have a non time64 test driver?|

Hi Alessandro,

We want to do away with set_mmss() eventually, time64 is the final version,
so I think this would be ok.

Thanks,
Xunlei

>
> --
>
>  Best regards,
>
>  Alessandro Zummo,
>   Tower Technologies - Torino, Italy
>
>   http://www.towertech.it
>
