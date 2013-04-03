Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761880Ab3DCNm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:42:29 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:38013
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759440Ab3DCNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:42:27 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] efi: Determine how much space is used by boot
 services-only variables
Thread-Topic: [PATCH 1/2] efi: Determine how much space is used by boot
 services-only variables
Thread-Index: AQHOLuuZAQK+HlxUokuQeY5w6zxM15jEevsAgAAJQ4A=
Date: Wed, 3 Apr 2013 13:42:13 +0000
Message-ID: <1364996531.19098.3.camel@x230>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	 <515C29EE.8050008@console-pimps.org>
In-Reply-To: <515C29EE.8050008@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EC700C260EFDF49920F59DBB85DF813@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r33DgSwJ028470

On Wed, 2013-04-03 at 14:09 +0100, Matt Fleming wrote:

> We're fixing a regression in efivars.c, but only for those users that
> boot via the EFI boot stub? That seems likely to upset some people.

Not really - it just makes the estimates more accurate. Applying (2)
without (1) should still fix the functional regression.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
