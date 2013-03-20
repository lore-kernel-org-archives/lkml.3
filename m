Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959Ab3CTBFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:05:32 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:34041
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934430Ab3CTBFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:05:30 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: PS2(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18deh18e1h1946h19b5h1ad9h1b0ah17ej1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 06/12] x86: Require CAP_COMPROMISE_KERNEL for IO port
 access
Thread-Topic: [PATCH 06/12] x86: Require CAP_COMPROMISE_KERNEL for IO port
 access
Thread-Index: Ac4lBv+qBFfPqh9EZkydMuGo4mRQ5Q==
Date: Wed, 20 Mar 2013 01:05:23 +0000
Message-ID: <2ad7xmbpwcl9vgjowbcqr2uu.1363741519451@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [::]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F37F080076B17A4F8ED37F7CE6790867@nebula.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2K15UQ7029636

Easiest way to do that would be to replace some existing users of CAP_RAW_IO with CAP_SYS_ADMIN and then just insert a couple of extra RAW_IO checks. That would break some existing userspace, but so would introducing a new capability. I'm happy to go that way, but would appreciate some broader feedback that that's the way to go. 
-- 
Matthew Garrett | matthew.garrett@nebula.comÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
