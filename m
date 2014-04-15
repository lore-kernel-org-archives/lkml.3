Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaDOD7f (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 14 Apr 2014 23:59:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43364 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaDOD7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:59:33 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Christian Engelmayer'" <cengelma@gmx.at>,
        "'Brian Norris'" <computersforpeace@gmail.com>
CC: "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?UkU6IFtQQVRDSF0gbXRkOiBuYW5kOiBvbWFwOiBmaXggY29tcGlsZSB3YXJu?=
 =?utf-8?B?aW5nIG9uIOKAmGVyYXNlZF9zZWN0b3JfYml0ZmxpcHPigJk=?=
Thread-Topic: =?utf-8?B?W1BBVENIXSBtdGQ6IG5hbmQ6IG9tYXA6IGZpeCBjb21waWxlIHdhcm5pbmcg?=
 =?utf-8?B?b24g4oCYZXJhc2VkX3NlY3Rvcl9iaXRmbGlwc+KAmQ==?=
Thread-Index: AQHPWDFq9uuDOOe8hUmJN9Bj3cgtEZsRd++AgACVVuA=
Date: Tue, 15 Apr 2014 03:58:56 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAC301C@DBDE04.ent.ti.com>
References: <20140415003205.0bb2cf44@spike>
 <007d01cf5842$435dcba0$ca1962e0$%han@samsung.com>
In-Reply-To: <007d01cf5842$435dcba0$ca1962e0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s3F3xkBP010138

>From: Jingoo Han [mailto:jg1.han@samsung.com]
>>On Tuesday, April 15, 2014 7:32 AM, Christian Engelmayer wrote:
>>
>> Commit 2c9f2365 (mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch4
>> in omap_calculate_ecc_bch) introduced minor compile warning
>> "â€˜erased_sector_bitflipsâ€™ defined but not used [-Wunused-function]" when
>> compiling without CONFIG_MTD_NAND_OMAP_BCH. Move function
>> erased_sector_bitflips() into the same ifdef section as the only caller.
>>
>> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
>
>Reviewed-by: Jingoo Han <jg1.han@samsung.com>
>
Thanks for the patch..
Acked-by: Pekon Gupta <pekon@ti.com>


With regards, pekon

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
