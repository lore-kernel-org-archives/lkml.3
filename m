Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3DXL52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:57:28 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:56953
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756857Ab3DXL50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:57:26 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: joeyli <jlee@suse.com>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
Thread-Topic: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
Thread-Index: AQHOOhU89r+iw6MpjUmtexdARM4dfpjlMy2AgAABzICAAAx2gIAAECUA
Date: Wed, 24 Apr 2013 11:57:21 +0000
Message-ID: <1366804640.13667.27.camel@x230.lan>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
	 <1366798111.23707.293.camel@linux-s257.site>
	 <1366798497.13667.25.camel@x230.lan>
	 <1366801173.23707.323.camel@linux-s257.site>
In-Reply-To: <1366801173.23707.323.camel@linux-s257.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <67BF1847ADD1D04F88C2569267721AB5@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3OBvqVs020658

On Wed, 2013-04-24 at 18:59 +0800, joeyli wrote:

> Then why we don't just remove the "remaining_size" condition but only
> monitor the active_size should not larger then 1/2 storage_size?

If we calculate active_size as using more than 50% of the storage space
but remaining_size says we still have more than 50% available, we should
trust remaining_size instead of active_size.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
