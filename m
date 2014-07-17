Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaGQJTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:19:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51229 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbaGQJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:19:35 -0400
Message-ID: <53C7951F.6000906@gmail.com>
Date: Thu, 17 Jul 2014 17:19:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, msalter@redhat.com,
        Guenter Roeck <linux@roeck-us.net>, linux-pwm@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        arnd@arndb.de, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <53C3994C.1010309@metafoo.de> <53C39B66.4060500@nod.at> <5A40E1FC-CA61-4AFF-B205-4BAC175AA7AC@gmail.com> <53C47725.8000005@gmail.com> <53C47B76.4080306@roeck-us.net> <53C47FB7.6080304@gmail.com> <53C53CE1.4090803@gmail.com> <53C7269E.4010702@gmail.com> <20140717083756.GA19686@ulmo> <53C7905D.9090003@gmail.com> <20140717091601.GF25880@mwanda>
In-Reply-To: <20140717091601.GF25880@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2014 05:16 PM, Dan Carpenter wrote:
> On Thu, Jul 17, 2014 at 04:59:09PM +0800, Chen Gang wrote:
>>>> +	return (__force void __iomem *)ERR_PTR(-ENXIO);
>>>
>>> There's apparently an IOMEM_ERR_PTR() for this nowadays...
>>>
>>
>> IOMEM_ERR_PTR() is defined within "lib/devres.c", not in "./include".
>> But may we move it from "lib/devres.c" to "./include/linux/err.h"?
>>
>> For me, I am not quite sure, it may need additional discussion, but at
>> least, that will be another patch.
> 
> Yes.  Move it there.  That is the right place.
> 

OK, thanks, if no another objections within 2 days, I shall send another
related patch for it.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
