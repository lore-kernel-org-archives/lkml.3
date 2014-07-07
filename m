Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaGGNDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:03:11 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36581 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaGGNDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:03:10 -0400
Message-ID: <53BA9A41.4050001@ahsoftware.de>
Date: Mon, 07 Jul 2014 15:01:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Roman Fietze <roman.fietze@telemotive.de>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 2/2] Allow to override the hctosys RTC using a kernel
 parameter
References: <5132579.sMfE4ssjXf@rfietze> <2398890.hEQ05gdLB8@rfietze>
In-Reply-To: <2398890.hEQ05gdLB8@rfietze>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.07.2014 13:50, schrieb Roman Fietze:
> Hello list members,
>
> And here the second part.
>
>
>  From e523006a34db26c274d3b71de5b914f476fb029e Mon Sep 17 00:00:00 2001
> From: Roman Fietze <roman.fietze@telemotive.de>
> Date: Fri, 4 Jul 2014 10:05:08 +0200
> Subject: [PATCH 2/2] rtc: add kernel parameter hctosys, use it instead of
>   CONFIG_RTC_HCTOSYS_DEVICE
>
> This change allows to overwrite the default of the hctosys RTC
> specified in the kernnel configuration by using a kernel parameter in
> the form of
>
>    hctosys=rtc<n>

Sorry for the confusion with my replies to the other patch. The 
Thunderbird on the used box got confused or confused me ("reply to list" 
just replied to the rtc-list and "reply to all" didn't add the the 
sender (Roman Fietze) to recipients. :/

Anyway, I think the whole rtcN mechanism is broken as you never can be 
sure which driver/RTC gets which N without testing every built kernel.

I've fixed that with the already mentioned patches here:

https://lkml.org/lkml/2014/6/13/6

Besides that, I wish you luck with your patches. ;)
