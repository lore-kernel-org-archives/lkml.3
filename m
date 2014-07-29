Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaG2H7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:59:33 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:45364
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbaG2H7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:59:32 -0400
Date: Tue, 29 Jul 2014 15:43:22 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/mach-imx/iomux: Do not export symbol without public
 declaration
Message-ID: <20140729074320.GC24750@dragon>
References: <1406185521-30803-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1406185521-30803-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(24454002)(74662001)(23726002)(76176999)(50986999)(85306003)(99396002)(83322001)(21056001)(31966008)(74502001)(57986006)(95666004)(84676001)(64706001)(19580405001)(83072002)(20776003)(87936001)(86362001)(46406003)(92566001)(80022001)(4396001)(47776003)(104016003)(85852003)(92726001)(44976005)(97756001)(97736001)(83506001)(106466001)(33716001)(79102001)(46102001)(81342001)(110136001)(26826002)(81542001)(68736004)(6806004)(105606002)(50466002)(77982001)(107046002)(102836001)(33656002)(76482001)(19580395003)(54356999);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB573;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 09:05:21AM +0200, Alexander Stein wrote:
> The iomux function declarations are in headers only accessible in this
> directory. Thus those can't be used in any module. None of the
> objects in this directory is tristate. Neither can the header be included
> in out-of-tree modules.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Changed patch prefix to 'ARM: imx: iomux: ...' and applied the patch.

Shawn
