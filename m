Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3FGNWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:22:43 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:36047
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753177Ab3FGNWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:22:42 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Adam Lee <adam.lee@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "ibm-acpi-devel@lists.sourceforge.net" 
	<ibm-acpi-devel@lists.sourceforge.net>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't
 have EC controllable LEDs
Thread-Topic: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which
 don't have EC controllable LEDs
Thread-Index: AQHOY1gzmacRmhLkTEmhzaeIETItNpkqPXgA
Date: Fri, 7 Jun 2013 13:22:39 +0000
Message-ID: <1370611358.6315.48.camel@x230.lan>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
	 <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
In-Reply-To: <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CE83064782ADE48B7EF93A328CBD754@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r57DNAsF020422

On Fri, 2013-06-07 at 16:20 +0800, Adam Lee wrote:
> Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs.
> This patch adds their quirks.

Can you detect this case? If this is a new way of doing things then
you're going to have to add new entries to the quirk list every time
Lenovo release a new machine, which isn't really going to work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
