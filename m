Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3AWXk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:40:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:37479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3AWXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:40:54 -0500
Message-ID: <51007545.5040406@infradead.org>
Date: Wed, 23 Jan 2013 15:41:57 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-iio@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 23 (mtd/ubi and iio and crypto/crc32[c])
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au> <51006DC9.30802@infradead.org> <20130123232316.GB25726@gondor.apana.org.au>
In-Reply-To: <20130123232316.GB25726@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/13 15:23, Herbert Xu wrote:
> On Wed, Jan 23, 2013 at 03:10:01PM -0800, Randy Dunlap wrote:
>> On 01/22/13 22:43, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20130122:
>>>
>>
>>
>> on i386:
>>
>> ERROR: "crc32_le" [drivers/mtd/ubi/ubi.ko] undefined!
>> ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/max1363.ko] undefined!
>> ERROR: "iio_triggered_buffer_cleanup" [drivers/iio/adc/max1363.ko] undefined!
>> ERROR: "__crc32c_le" [crypto/crc32c.ko] undefined!
>> ERROR: "crc32_le" [crypto/crc32.ko] undefined!
> 
> Weird.  You do have CONFIG_CRC32 selected, so did it compile
> a lib/crc32.ko or not?

Hmph, this seems to be some kind of rebuild problem.  It's not
reproducible, so the mtd/ubi and crypto reports above are incorrect --
please ignore them.  Only the iio one is reproducible.

Sorry about that.

-- 
~Randy
