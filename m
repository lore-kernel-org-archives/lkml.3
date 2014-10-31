Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161456AbaJaAi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:38:28 -0400
Received: from mail-by2on0132.outbound.protection.outlook.com ([207.46.100.132]:60668
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161361AbaJaAi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:38:26 -0400
Date: Fri, 31 Oct 2014 08:38:14 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141031003812.GA3692@peterchendt>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman> <20141030163513.GI10130@saruman>
 <20141030174254.GA6764@kwain> <20141030174734.GA6652@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141030174734.GA6652@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(189002)(24454002)(199003)(51704005)(46102003)(80022003)(93886004)(85306004)(97736003)(31966008)(120916001)(57986006)(110136001)(104016003)(21056001)(99396003)(76482002)(54356999)(86362001)(76176999)(92566001)(92726001)(50986999)(33656002)(26826002)(95666004)(81156004)(107046002)(102836001)(106466001)(46406003)(47776003)(64706001)(20776003)(97756001)(85852003)(33716001)(4396001)(50466002)(84676001)(83506001)(19580395003)(6806004)(44976005)(68736004)(87936001)(19580405001)(23726002)(69596002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0626;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=temperror (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:47:34PM -0500, Felipe Balbi wrote:
> On Thu, Oct 30, 2014 at 06:42:54PM +0100, Antoine Tenart wrote:
> > Hi Felipe,
> > 
> > On Thu, Oct 30, 2014 at 11:35:13AM -0500, Felipe Balbi wrote:
> > > On Thu, Oct 30, 2014 at 11:31:48AM -0500, Felipe Balbi wrote:
> > > > On Tue, Oct 28, 2014 at 05:35:35PM +0100, Antoine Tenart wrote:
> > > > > Before using the PHY framework instead of the USB PHY one, we need to
> > > > > move the OTG state into another place, since it won't be available when
> > > > > USB PHY isn't used. This patch moves the OTG state into the OTG
> > > > > structure, and makes all the needed modifications in the drivers
> > > > > using the OTG state.
> > > > > 
> > > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > > > Acked-by: Peter Chen <peter.chen@freescale.com>
> > > > 
> > > > Acked-by: Felipe Balbi <balbi@ti.com>
> > > 
> > > Please rebase on my testing/next and I'll take the series. When
> > > rebasing, then add Peter's Tested-by/Acked-by where they're missing.
> > 
> > I just re-sent the series, rebased on your testing/next branch.
> 
> Thanks, I put them on my testing/next and I'm running build tests.
> 

I see them, I will rebase your testing/next tree for coming chipidea dev, thanks.

-- 
Best Regards,
Peter Chen
