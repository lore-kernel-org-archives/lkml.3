Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3LaSBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:01:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49982 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LaSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:01:23 -0500
Message-ID: <52C3066E.1070909@infradead.org>
Date: Tue, 31 Dec 2013 10:01:18 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
References: <m3d2kduwd7.fsf@t19.piap.pl> <20131231134820.GS8064@book.gsilab.sittig.org>
In-Reply-To: <20131231134820.GS8064@book.gsilab.sittig.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/13 05:48, Gerhard Sittig wrote:
> On Tue, Dec 31, 2013 at 11:51 +0100, Krzysztof Hałasa wrote:
>>
>> drivers/crypto/ixp4xx_crypto.c: In function 'ixp_module_init':
>> drivers/crypto/ixp4xx_crypto.c:1419:2: error: 'dev' undeclared (first use in this function)
>>
>> Now builds. Not tested on real hw.
>>
>> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> I understood that a 'Fixes: <hash> <subject>' line is suggested when
> you can clearly identify what broke what you fix.  Is it 27c1789ca6a6
> "DMA-API: crypto: remove last references to 'static struct device *dev'"?
> Then v3.13-rc1 would have been affected.
 
is 'Fixes: <whatever>' documented somewhere?

thanks,
-- 
~Randy
