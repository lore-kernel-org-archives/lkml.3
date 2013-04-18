Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967019Ab3DRPBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:01:19 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:32188
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965906Ab3DRPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:01:17 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dI936eI4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Josh Boyer <jwboyer@redhat.com>
CC: Matt Fleming <matt@console-pimps.org>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <darren.hart@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Thread-Topic: [PATCH] Remove warning in efi_enter_virtual_mode
Thread-Index: AQHOOrruj8eFhjMAhk2umQbQokvUbJjac+0AgACEpgCAANnTAIAALNyAgAAWaIA=
Date: Thu, 18 Apr 2013 15:01:12 +0000
Message-ID: <1366297271.13667.14.camel@x230.lan>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
	 <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie>
	 <516FD24A.3070502@console-pimps.org>
	 <20130418134059.GF18383@hansolo.jdub.homelinux.org>
In-Reply-To: <20130418134059.GF18383@hansolo.jdub.homelinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <42209C1F464620409A5718816AEC3EF7@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3IF1Oxr017872

On Thu, 2013-04-18 at 09:40 -0400, Josh Boyer wrote:

> BGRT is a new addition in ACPI 5.0, right?  Hopefully with it being
> relatively recent, and new 32-bit firmware being somewhat rare, it won't
> be a problem.

New 32-bit UEFI firmware is fairly common. Thanks, Intel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
