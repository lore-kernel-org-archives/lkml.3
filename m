Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbaGPAuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:50:02 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:56508
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754124AbaGPAuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:50:00 -0400
Date: Wed, 16 Jul 2014 08:44:32 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: punnaiah choudary kalluri <punnaia@xilinx.com>,
        <sebastian.hesselbarth@gmail.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140716004431.GB30419@shlinux1.ap.freescale.net>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <CAGnW=BbA3gLdSv8AKkD_ysnYAaN0KoCdVW+wxWPB9zzGCh9+jQ@mail.gmail.com>
 <20140715152437.GF1011@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140715152437.GF1011@kwain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(199002)(51704005)(87936001)(74502001)(86362001)(50466002)(74662001)(102836001)(93886003)(76482001)(97736001)(92726001)(81542001)(83072002)(81342001)(107046002)(85852003)(23756003)(33656002)(26826002)(77982001)(6806004)(85306003)(4396001)(106466001)(81156004)(54356999)(110136001)(99396002)(64706001)(84676001)(20776003)(47776003)(76176999)(80022001)(50986999)(79102001)(31966008)(95666004)(104016003)(92566001)(105606002)(46102001)(83506001)(21056001)(69596002)(44976005)(68736004)(83322001)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB575;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0274272F87
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:24:37PM +0200, Antoine Ténart wrote:
> Hi,
> 
> On Thu, Jul 03, 2014 at 08:17:34AM +0530, punnaiah choudary kalluri wrote:
> > Since its a generic driver, support for configuring the dma_mask using
> > dma_coerce_mask_and_coherent would be good.
> > 
> 
> Should I add a DMA mask dt property? Or just not add this and wait for
> someone needing it in his case?
> 

As a dt property, since most of platforms will use it. For PIO mode, the
property can be NULL.

-- 

Best Regards,
Peter Chen
