Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaHZVHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:07:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbaHZVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:07:16 -0400
Message-ID: <53FCF700.7020107@infradead.org>
Date: Tue, 26 Aug 2014 14:07:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 26 (drbg)
References: <20140826173452.7cc5445c@canb.auug.org.au> <53FCDA03.3050504@infradead.org> <2143681.nIInT2cPxl@myon.chronox.de>
In-Reply-To: <2143681.nIInT2cPxl@myon.chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 13:19, Stephan Mueller wrote:
> Am Dienstag, 26. August 2014, 12:03:31 schrieb Randy Dunlap:
> 
> Hi Randy,
> 
>> On 08/26/14 00:34, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20140825:
>>>
>>> The net tree gained a build failure for which I reverted a commit.
>>>
>>> The mfd tree still had its build failure so I used the version from
>>> next-20140822.
>>
>> on i386:
>>
>> ../include/crypto/drbg.h:157:2: warning: left shift count >= width of type
>> [enabled by default] ../include/crypto/drbg.h:163:2: warning: left shift
>> count >= width of type [enabled by default]
>>
>> I guess that someone has already seen this but I haven't noticed any reports
>> of it.
> 
> Thank you for reporting the issue. The patch and fix is provided with [1]. Did 
> you test with this patch?
> 
> [1] 
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=b9347aff91ce4789619168539f08202d8d6a1177
> 

I tested whatever is in linux-next of 20140826.

I'll check that commit later, got to run errands now.

Thanks.

-- 
~Randy
