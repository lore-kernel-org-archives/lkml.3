Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaLNOAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:00:41 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaLNOAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:00:40 -0500
Message-ID: <548D9802.1030300@nod.at>
Date: Sun, 14 Dec 2014 15:00:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>, dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: UBI: Add support for scatter gather and blk-mq
References: <1416845080-16663-1-git-send-email-richard@nod.at> <548D85F1.5080606@vanguardiasur.com.ar>
In-Reply-To: <548D85F1.5080606@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.12.2014 um 13:43 schrieb Ezequiel Garcia:
> Hey Richard,
> 
> On 11/24/2014 01:04 PM, Richard Weinberger wrote:
>> This two patches implement blk-mq support for the UBI block driver.
>> As the scatter gather part is rather generic I've moved it directl
>> into UBI such that it can be reused later.
>> So far only reading data into a scatter gather list is possible.
>> After implementing  ubi_eba_read_leb_sg() we could slowly start
>> removing a bunch of vmalloc() from the UBI core code and use scatter gather.
>> This should lower the memory footprint of UBI.
>>
>> [PATCH 1/2] UBI: Add initial support for scatter gather
>> [PATCH 2/2] UBI: Block: Add blk-mq support
>>
> 
> Tried to apply these to take a look and run some tests, but 2/2 got
> rejected. Which tag did you base them?

Which hunk does not apply?
What tree are you using?

Here it applies fine Linus' tree as of today and linux-ubifs.git.

Thanks,
//richard
