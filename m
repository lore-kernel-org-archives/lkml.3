Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3FCQbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:31:50 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:46974
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758695Ab3FCQbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:31:41 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: joeyli <jlee@suse.com>
CC: "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Thread-Topic: [PATCH] Modify UEFI anti-bricking code
Thread-Index: AQHOXwRQ69J870D+8ESfIa4gHR89tpkkLJYAgAAE7oA=
Date: Mon, 3 Jun 2013 16:31:21 +0000
Message-ID: <1370277079.6315.14.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
In-Reply-To: <1370276021.30695.4.camel@linux-s257.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BL2PR05MB211;H:BL2PR05MB211.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <79898D7D92BE2C4592A79AAD001919B5@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r53GW1Kb009134

On Tue, 2013-06-04 at 00:13 +0800, joeyli wrote:

> Oliver raised a question for if power fails between that succesful
> attempt and the deletion?

It's a pretty tiny window, but sure. Making sure we delete it seems
sensible. In that case we should make the GUID a #define rather than
write it out twice.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
