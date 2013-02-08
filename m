Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946904Ab3BHTSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:18:40 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56732 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946814Ab3BHTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:18:36 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kees Cook <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Topic: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Index: AQHOBjA7mQsIMlqU/k+EElzc7Yz1iZhwVXyA
Date: Fri, 8 Feb 2013 19:17:28 +0000
Message-ID: <1360351047.18083.14.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
In-Reply-To: <20130208191213.GA25081@www.outflux.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8A41633817DA54C8C0DF1F899C08210@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r18JIgZD005388

On Fri, 2013-02-08 at 11:12 -0800, Kees Cook wrote:
> Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
> set since it could lead to execution of arbitrary code in kernel mode.

Willing to buy this, but do you have a description of one potential
approach? We should probably also figure out what's writing to MSRs at
the moment (anything other than energy_perf_bias?) and decide what the
best thing to do there is.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
