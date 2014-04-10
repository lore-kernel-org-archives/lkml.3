Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870AbaDJIsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:48:05 -0400
Received: from mx0.aculab.com ([213.249.233.131]:34283 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934827AbaDJIr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:47:59 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'hongbo.zhang@freescale.com'" <hongbo.zhang@freescale.com>,
        "vkoul@infradead.org" <vkoul@infradead.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leo.li@freescale.com" <leo.li@freescale.com>
Subject: RE: [PATCH v3 2/8] DMA: Freescale: unify register access methods
Thread-Topic: [PATCH v3 2/8] DMA: Freescale: unify register access methods
Thread-Index: AQHPVIwscLmSTUF77U2iQVdtFyt/4psKiVzw
Date: Thu, 10 Apr 2014 08:46:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6F4317@AcuExch.aculab.com>
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com>
 <1397113805-24171-3-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1397113805-24171-3-git-send-email-hongbo.zhang@freescale.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3A8mHZl026068

From: hongbo.zhang@freescale.com
> Methods of accessing DMA contorller registers are inconsistent, some registers
                               ^^
> are accessed by DMA_IN/OUT directly, while others are accessed by functions
> get/set_* which are wrappers of DMA_IN/OUT, and even for the BCR register, it
> is read by get_bcr but written by DMA_OUT.
> This patch unifies the inconsistent methods, all registers are accessed by
> get/set_* now.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
