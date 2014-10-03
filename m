Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaJCT22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:28:28 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36320 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaJCT2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:28:23 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build warnings after merge of the akpm-current tree
In-Reply-To: <20141003112154.92b5a47b2009293090d18f5a@linux-foundation.org>
Organization: http://mina86.com/
References: <20141003173004.7ac4edce@canb.auug.org.au> <20141003112154.92b5a47b2009293090d18f5a@linux-foundation.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141003:joshc@codeaurora.org::2HODjbIoIGzoQnPw:000000000000000000000000000000000000000000Atc
X-Hashcash: 1:20:141003:lauraa@codeaurora.org::PyrquoOWMvJa0ydi:00000000000000000000000000000000000000002BHl
X-Hashcash: 1:20:141003:iamjoonsoo.kim@lge.com::dM3rjkhqOf5q67UU:00000000000000000000000000000000000000021Cz
X-Hashcash: 1:20:141003:linux-kernel@vger.kernel.org::0K7PrEk4hcTT2ZW9:0000000000000000000000000000000002ZsD
X-Hashcash: 1:20:141003:grant.likely@linaro.org::4QLHD2q8HTALj0ei:000000000000000000000000000000000000002zH0
X-Hashcash: 1:20:141003:kyungmin.park@samsung.com::S36mEe/240Mce3Pi:0000000000000000000000000000000000003id4
X-Hashcash: 1:20:141003:m.szyprowski@samsung.com::Fba0S43bQCzvCKRR:00000000000000000000000000000000000003lF0
X-Hashcash: 1:20:141003:arnd@arndb.de::yq6m+P69o/1jrjyN:00003kyq
X-Hashcash: 1:20:141003:akpm@linux-foundation.org::7yurEZnqaioVT2sr:0000000000000000000000000000000000007z+f
X-Hashcash: 1:20:141003:linux-next@vger.kernel.org::TF4amvem1jj8XiTo:00000000000000000000000000000000000Auan
X-Hashcash: 1:20:141003:sfr@canb.auug.org.au::ajAa6uF11+q9Fk12:00000000000000000000000000000000000000000G8NG
Date: Fri, 03 Oct 2014 21:28:17 +0200
Message-ID: <xa1tr3yp2bse.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03 2014, Andrew Morton wrote:
> On Fri, 3 Oct 2014 17:30:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi Andrew,
>> 
>> After merging the akpm-current tree, today's linux-next build (arm
>> multi_v7_defconfig) produced these warnings:
>> 
>> drivers/base/dma-contiguous.c:244:2: warning: initialization from incompatible pointer type
>>   .device_init = rmem_cma_device_init,
>>   ^
>> drivers/base/dma-contiguous.c:244:2: warning: (near initialization for 'rmem_cma_ops.device_init')
>> drivers/base/dma-coherent.c:303:2: warning: initialization from incompatible pointer type
>>   .device_init = rmem_dma_device_init,
>>   ^
>> 
>> Introduced by commit e92f6296f3a2 ("drivers: dma-coherent: add
>> initialization from device tree").  This init routine is supposed to
>> return void ...
>
> I'm a bit reluctant to just go in and change rmem_cma_device_init().
>
> Why does it test for rmem->priv==NULL?  Can that really happen?  Why? 
> Is it a legitimate state?

I don't think so, since:

static int __init rmem_cma_setup(struct reserved_mem *rmem)
{
	[…]
	rmem->ops = &rmem_cma_ops;
	rmem->priv = cma;
	[…]
}

The following should fix the warning:

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 6c42289..a9a88b6 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -223,14 +223,9 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
-static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
-	struct cma *cma = rmem->priv;
-
-	if (!cma)
-		return -ENODEV;
-
-	dev_set_cma_area(dev, cma);
+	dev_set_cma_area(dev, rmem->priv);
 	return 0;
 }

Even if rmem->priv is NULL, the call will simply clear device's
cma_area, but at this point it should be NULL anyway.
 
> And why does dev_set_cma_area() test for dev==NULL?  Can that really
> happen?  Is it legitimate?  Is all this stuff just papering over other
> bugs?

I believe since a2547380393ac82c659b40182b0da8d05a8365f3 dev no longer
can be NULL.  It should be safe to apply this:

diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
index 569bbd0..ff9804e 100644
--- a/include/linux/dma-contiguous.h
+++ b/include/linux/dma-contiguous.h
@@ -71,8 +71,7 @@ static inline struct cma *dev_get_cma_area(struct device *dev)
 
 static inline void dev_set_cma_area(struct device *dev, struct cma *cma)
 {
-	if (dev)
-		dev->cma_area = cma;
+	dev->cma_area = cma;
 }
 
 static inline void dma_contiguous_set_default(struct cma *cma)

>
> The whole thing could do with a bit of an audit and cleanup, I suspect.
> Get the states and initialization sequences and error checking all
> sorted out, then get rid of all these tests for NULL.
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
