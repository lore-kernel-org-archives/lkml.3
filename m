Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaEVEkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:40:06 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55225 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaEVEkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:40:05 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537D7FA4.30501@lge.com>
Date: Thu, 22 May 2014 13:40:04 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [RFC] I found an errataum at drivers/base/dma-contiguous.c:294
References: <537D54D3.9060908@lge.com> <alpine.DEB.2.02.1405211953490.13243@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405211953490.13243@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks your advice.
I'll send a patch soon.


2014-05-22 오전 11:54, David Rientjes 쓴 글:
> On Thu, 22 May 2014, Gioh Kim wrote:
>
>> This is not a big deal but I think get_dev_cma_area is errataum of dev_get_cma_area.
>>
>
> Looks good, but you may want to read Documentation/SubmittingPatches when
> proposing patches.
>
