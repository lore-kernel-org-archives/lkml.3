Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3FQWhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:37:15 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:53373
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750929Ab3FQWhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:37:13 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 2/3] ACPICA: Add interface for getting latest OS version
 requested via _OSI
Thread-Topic: [PATCH 2/3] ACPICA: Add interface for getting latest OS
 version requested via _OSI
Thread-Index: AQHOZWVcZv9ghtKEtkauS5XQLu7/+Jk6ifUAgAABp4A=
Date: Mon, 17 Jun 2013 22:37:10 +0000
Message-ID: <1371508629.523.3.camel@x230>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1370818899-8595-3-git-send-email-matthew.garrett@nebula.com>
	 <2212597.t9jOQU2YXi@vostro.rjw.lan>
In-Reply-To: <2212597.t9jOQU2YXi@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <48EC2C70E1EEA0488C95994175F333B9@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5HMbMkl026000

On Tue, 2013-06-18 at 00:31 +0200, Rafael J. Wysocki wrote:
> Hi Matthew,
> 
> On Sunday, June 09, 2013 07:01:38 PM Matthew Garrett wrote:
> > Drivers may need to make policy decisions based on the OS that the firmware
> > believes it's interacting with. ACPI firmware will make a series of _OSI
> > calls, starting from the oldest OS version they support and ending with the
> > most recent. Add a function to return the last successful call so that
> > drivers know what the firmware's expecting.
> > 
> > Based on a patch by Seth Forshee <seth.forshee@canonical.com>
> 
> Bob (CCed) would prefer us to access acpi_gbl_osi_data directly instead of
> adding the wrapper to ACPICA.  He also thinks that the symbol definitions
> should go into include/acpi/actypes.h rather than into acpixf.h.
> 
> Then, the only ACPICA change would be to move the symbols and we can
> add a Linux-specific patch on top of that adding the acpi_gbl_osi_data
> wrapper.

That sounds good to me. Do you want to respin that, or should I send an
updated set?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
