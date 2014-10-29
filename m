Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490AbaJ2RAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:00:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56730 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaJ2RAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:00:24 -0400
Message-ID: <54511D26.7050000@codeaurora.org>
Date: Wed, 29 Oct 2014 10:00:22 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gioh Kim <gioh.kim@lge.com>, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, rebecca@android.com, dan.carpenter@oracle.com,
        Minchan Kim <minchan@kernel.org>,
        =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Subject: Re: [RFC] stating: ion: use hot page first in pool
References: <545073AB.5060502@lge.com>
In-Reply-To: <545073AB.5060502@lge.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 9:57 PM, Gioh Kim wrote:
> 
> Hello,
> 
> I found that ion insert freed-page at the tail of list
> and extract at the head.
> 
> I think it is good for cache to use the most recently used page
> but these pages in pool are not cached memory.
> So I'm not sure using hot page is better or not in this case.
> 
> What do you think about using hot page first?
> 

This is something that really needs data collection and
benchmarks to see if there is actually an improvement or not.

Thanks,
Laura



-- 
Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
