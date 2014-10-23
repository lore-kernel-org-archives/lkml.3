Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbaJWA7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:59:32 -0400
Received: from mailout.micron.com ([137.201.242.129]:21395 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaJWA7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:59:31 -0400
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1 v3] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Topic: [PATCH 1/1 v3] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Index: AQHP2KkjagwG2in0R7+6ioZ2PHnYSpwTG1RugAKuPPCAAgpzkIADfZeAgBhBsxCABMQ/MIAEr5YQ
Date: Thu, 23 Oct 2014 00:58:44 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E77C1@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>     
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21044.002
X-TM-AS-Result: No-0.392500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.

>For Micron SPI NOR flash, enabling or disabling quad I/O protocol is controlled by 
>EVCR (Enhanced Volatile Configuration Register), Quad I/O protocol bit 7. 
>When EVCR bit 7 is reset to 0, the SPI NOR flash will operate in quad I/O mode.

>Signed-off-by: bean huo <beanhuo@micron.com>
>Acked-by: Marek Vasut <marex@denx.de>

Hi,Brian
Is this patch OK?
