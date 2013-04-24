Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3DXPBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:01:50 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39193 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab3DXPBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:01:49 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIda00hdc73hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: Josh Boyer <jwboyer@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] efi: Check EFI revision in setup_efi_vars
Thread-Topic: [PATCH] efi: Check EFI revision in setup_efi_vars
Thread-Index: AQHOQPlQHRjt8E2oC0WuAZ0KRwVwspjlcoEAgAAC4oCAAACkgIAAATSA
Date: Wed, 24 Apr 2013 15:01:26 +0000
Message-ID: <1366815685.9976.0.camel@x230>
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org>
	 <5177EFCE.80104@intel.com>
	 <20130424145449.GC15272@hansolo.jdub.homelinux.org>
	 <5177F2C3.5080907@intel.com>
In-Reply-To: <5177F2C3.5080907@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFC7B3F97326194194E857ED1ADE118C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3OF1t9B021720

On Wed, 2013-04-24 at 15:57 +0100, Matt Fleming wrote:

> I presume that if that were true, virt_efi_query_variable_info() (which
> is called indirectly from the efivars code) would have exploded before
> now. Matthew?

Yeah, it's probably safe to lose it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
