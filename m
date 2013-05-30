Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab3E3WYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:24:15 -0400
Received: from [207.46.163.242] ([207.46.163.242]:3383 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758693Ab3E3WYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:24:07 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Russ Anderson <rja@sgi.com>
CC: joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Thread-Topic: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Thread-Index: AQHOXYQW/WUBwmRoikKwtmPDRFxJOQ==
Date: Thu, 30 May 2013 22:21:53 +0000
Message-ID: <1369952512.11620.14.camel@x230>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	 <1369880172.17397.11.camel@linux-s257.site>
	 <20130530221737.GA11105@sgi.com>
In-Reply-To: <20130530221737.GA11105@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B28F84BEE998BE48B236D6091652B5C3@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4UMOXeL020937

On Thu, 2013-05-30 at 17:17 -0500, Russ Anderson wrote:

> That's a great idea.  This patch moves the QueryVariableInfo()
> call from bootime to runtime, in efi_late_init().  The attached
> patch is consistent with the UEFI spec and avoids the problem.

No, that defeats the entire point of the original patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
