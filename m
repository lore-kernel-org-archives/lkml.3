Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3DRT6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:58:46 -0400
Received: from [213.199.154.208] ([213.199.154.208]:3446 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752695Ab3DRT6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:58:44 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: Josh Triplett <josh@joshtriplett.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <darren.hart@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Thread-Topic: [PATCH] Remove warning in efi_enter_virtual_mode
Thread-Index: AQHOOrruj8eFhjMAhk2umQbQokvUbJjac+0AgACEpgCAANnTAIAAXQoAgAABTACAAAHtAIAANTAAgAAAw4A=
Date: Thu, 18 Apr 2013 19:58:03 +0000
Message-ID: <1366315083.13667.19.camel@x230.lan>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
	 <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie>
	 <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf>
	 <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf>
	 <51704FA8.7060801@console-pimps.org>
In-Reply-To: <51704FA8.7060801@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4A3B1B37188294BA13C5A563951A0B7@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3IJwpTj019866

On Thu, 2013-04-18 at 20:55 +0100, Matt Fleming wrote:

> If there are machines out there that would require us to write support,
> it's probably worth doing now instead of punting. But it sounds like
> there aren't any.

I would expect that if there are any 32-bit UEFI systems that ship with
BGRT support (and Darren makes it sound like that's a possibility),
there's a realistic chance of the BGRT ending up allocated above the
highmem barrier.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
