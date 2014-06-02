Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaFBGhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:37:31 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:10931
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387AbaFBGh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:37:28 -0400
Date: Mon, 2 Jun 2014 14:37:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
Message-ID: <20140602063702.GB7834@dragon>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(26826002)(64706001)(74662001)(83322001)(84676001)(46406003)(68736004)(44976005)(86362001)(97756001)(20776003)(83072002)(21056001)(87936001)(50466002)(104016001)(92726001)(102836001)(23726002)(31966008)(99396002)(33656002)(77982001)(80022001)(46102001)(54356999)(47776003)(74502001)(6806004)(33716001)(57986005)(85852003)(83506001)(97736001)(81342001)(79102001)(92566001)(4396001)(76176999)(76482001)(81542001)(77096999)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB360;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0230B09AC4
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:30:00AM -0400, Santosh Shilimkar wrote:
> Here is an updated v3 of the series. Series introduces support for setting up
> dma parameters based on device tree properties like 'dma-ranges' and
> 'dma-coherent' and also update to ARM 32 bit port. Earlier version of the
> series can be found here [3], [2] and [1].

Are these two generic device tree properties documented somewhere under
Documentation/devicetree/bindings?

Shawn
