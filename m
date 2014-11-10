Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaKJODa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:03:30 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:57505 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaKJOD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:03:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141110135328.GB24004@x1>
References: <1415263958-16644-1-git-send-email-dbaryshkov@gmail.com>
	<20141106090424.GB26543@x1>
	<20141110135328.GB24004@x1>
Date: Mon, 10 Nov 2014 18:03:28 +0400
Message-ID: <CALT56yMq2Mz1xSOKpBBGRRFHuiURhdoCSgXEX-31LPJiXBrtOA@mail.gmail.com>
Subject: Re: [PATCH] mfd: tc6393xb: prepare/unprepare clocks
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-10 16:53 GMT+03:00 Lee Jones <lee.jones@linaro.org>:
> On Thu, 06 Nov 2014, Lee Jones wrote:
>
>> On Thu, 06 Nov 2014, Dmitry Eremin-Solenikov wrote:
>>
>> > Change clk_enable/disable() calls to clk_prepare_enable() and
>> > clk_disable_unrepapre().
>> >
>> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> > ---
>> >  drivers/mfd/tc6393xb.c | 10 +++++-----
>> >  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> Applied, thanks.
>
> OOI, what kernel version was this patch based on?

v3.18-rc something. It is not required for previous kernel versions,
since machines with
these chips (PXA-based) do not use COMMON_CLK (and thus do not trigger
a warning).
Robert Jarzmik started converting pxa to common clocks framework and
thus I spotted
the warning.

-- 
With best wishes
Dmitry
