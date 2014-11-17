Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaKQGhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:37:43 -0500
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:8928
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaKQGhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:37:41 -0500
Date: Mon, 17 Nov 2014 13:30:47 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] usb: chipidea: add a core function to setup
 ci_hdrc_platform_data
Message-ID: <20141117053044.GA30017@shlinux2>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414669007-9850-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141114011651.GA28697@shlinux2> <20141114153455.GC2991@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141114153455.GC2991@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(51704005)(164054003)(102836001)(33656002)(50466002)(97756001)(4396001)(110136001)(104016003)(106466001)(46102003)(21056001)(105606002)(95666004)(107046002)(97736003)(50986999)(76176999)(54356999)(99396003)(120916001)(92566001)(31966008)(62966003)(47776003)(92726001)(77156002)(86362001)(33716001)(23726002)(20776003)(84676001)(68736004)(87936001)(6806004)(93886004)(44976005)(64706001)(83506001)(46406003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 03982FDC1D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 04:34:55PM +0100, Antoine Tenart wrote:
> Peter,
> 
> On Fri, Nov 14, 2014 at 09:16:55AM +0800, Peter Chen wrote:
> > 
> > Ok, Antoine, I find this patch set may not have many benefits due to
> > below reasons:
> > - There is already function ci_get_platdata to do the similar things
> > - If the PHY can't get from the DT, it will use devm_phy_get or
> > devm_usb_get_phy to get, this code has already in core.
> > 
> > I am apologized that I wanted you to do a patch for moving get PHY
> > operation to core, it doesn't have many benefits currently
> > - For non-dt user, the phy get function has already in core like I said
> > above.
> > - For dt generic phy user, it uses of_phy_get, the second parameter
> > con_id may be different for platforms.
> > - For dt usb phy, it uses devm_usb_get_phy_by_phandle, the second
> > parameters phandle may be different for platforms.
> 
> Ok.
> 
> > So, please rebase my next tree which your generic phy patch set has
> > already in, and send your generic usb2 chipidea patch base on it.
> 
> I just rebased my usb2 ci generic driver series and sent it to you and
> to the mailing lists. Since there is not reason from now to delay it, I
> expect it to be merged soon. I wouldn't want to miss yet another release.
> 
> Thanks,
> 

I hope soon, just your generic phy patch set changed lots of things, and
spent too much time on reviewing.

-- 

Best Regards,
Peter Chen
