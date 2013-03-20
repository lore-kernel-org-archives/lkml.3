Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3CTSMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:12:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19905 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab3CTSMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:12:44 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Thread-Topic: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Thread-Index: AQHOJCAqmvU0usyXI0yxxCAslUbX+ZiscZuAgAJZ0ICAAAIXAIAAFDYAgAADCQA=
Date: Wed, 20 Mar 2013 18:12:38 +0000
Message-ID: <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
	 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
	 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
	 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
	 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
In-Reply-To: <1363802506.2580.55.camel@falcor1.watson.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D5CF2C08100094E80297D4B419C1B64@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2KICo9e001722

On Wed, 2013-03-20 at 14:01 -0400, Mimi Zohar wrote:

> Sorry, I'm not sure to which work you're referring. If you're referring
> to Dmitry's "initramfs with digital signature protection" patches, then
> we're speaking about enforcing integrity, not MAC security.  

Well, in the absence of hardcoded in-kernel policy, there needs to be
some mechanism for ensuring the integrity of a policy. Shipping a signed
policy initramfs fragment and having any Secure Boot bootloaders pass a
flag in bootparams indicating that the kernel should panic if that
fragment isn't present would seem to be the easiest way of doing that.
Or have I misunderstood the question?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
