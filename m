Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKFC5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:57:40 -0500
Received: from mailout.micron.com ([137.201.242.129]:38042 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKFC5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:57:39 -0500
From: bpqw <bpqw@micron.com>
To: Brian Norris <computersforpeace@gmail.com>, bpqw <bpqw@micron.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1 v4] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [PATCH 1/1 v4] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHP+OyDxaNK6v1UTk6KxHoL3znnipxS5hNw
Date: Thu, 6 Nov 2014 02:56:53 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EA23A@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315E9B48@NTXXIAMBX02.xacn.micron.com>
 <20141105112633.GK22361@norris-Latitude-E6410>
In-Reply-To: <20141105112633.GK22361@norris-Latitude-E6410>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21078.003
X-TM-AS-Result: No--2.986200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.

>Also, your patch is still corrupt and cannot be applied as-is. 
>Please double-check your mailer settings and resend once you have something I can apply.

>Brian

Hi,Brian

Thanks your patience.this maybe linux kernel has been updated again.
My patch based linux kernel is old. I will rebuild a new patch based
on latest linux-mtd,and submit it today.
This patch has been waiting for your reply too long time.I really hope
that this patch to be accepted as soon as possible, otherwise I will
rebuild it again,and one by one.
