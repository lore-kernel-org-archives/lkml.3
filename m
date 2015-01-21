Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbbAUA2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:28:34 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbAUA2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:28:31 -0500
Message-ID: <54BEF2AE.7050007@infradead.org>
Date: Tue, 20 Jan 2015 16:28:30 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
CC: linux-crypto@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: Documentation: remove colons in comments
References: <4431066.AhB5zCO9nr@tachyon.chronox.de> <20150120034750.GB11274@gondor.apana.org.au>
In-Reply-To: <20150120034750.GB11274@gondor.apana.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/15 19:47, Herbert Xu wrote:
> On Mon, Jan 19, 2015 at 12:13:39AM +0100, Stephan Mueller wrote:
>> As documented in Documentation/kernel-doc-nano-HOWTO.txt lines
>> terminated with a colon are treated as headings.
>>
>> The current layout of the documentation when compiling the kernel
>> crypto API DocBook documentation is messed up by by treating some lines
>> as headings. The patch removes colons from comments that shall not be
>> treated as headings.
>>
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Applied.
> 

Ack. Thanks.

-- 
~Randy
