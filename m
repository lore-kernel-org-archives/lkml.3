Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbaJ2XJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:09:54 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:49281 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaJ2XJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:09:53 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <545173BE.2050805@lge.com>
Date: Thu, 30 Oct 2014 08:09:50 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, rebecca@android.com, dan.carpenter@oracle.com,
        Minchan Kim <minchan@kernel.org>,
        =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Subject: Re: [RFC] stating: ion: use hot page first in pool
References: <545073AB.5060502@lge.com> <54511D26.7050000@codeaurora.org>
In-Reply-To: <54511D26.7050000@codeaurora.org>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-30 오전 2:00에 Laura Abbott 이(가) 쓴 글:
> On 10/28/2014 9:57 PM, Gioh Kim wrote:
>>
>> Hello,
>>
>> I found that ion insert freed-page at the tail of list
>> and extract at the head.
>>
>> I think it is good for cache to use the most recently used page
>> but these pages in pool are not cached memory.
>> So I'm not sure using hot page is better or not in this case.
>>
>> What do you think about using hot page first?
>>
> 
> This is something that really needs data collection and
> benchmarks to see if there is actually an improvement or not.
> 
> Thanks,
> Laura
> 
> 
> 
Thank you for always.
I'm looking for a benchmark tool for my platform, but not founding yet.
