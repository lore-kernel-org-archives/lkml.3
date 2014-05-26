Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaEZHtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:49:43 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:7612
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751826AbaEZHtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:49:39 -0400
Date: Mon, 26 May 2014 15:49:15 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Cosmin Stoica <cosminstefan.stoica@freescale.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: linux-next: manual merge of the clockevents tree with the
 arm-soc tree
Message-ID: <20140526074913.GD2650@dragon>
References: <20140526154331.7fc6b30c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140526154331.7fc6b30c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(80022001)(77096999)(57986005)(6806004)(76176999)(50986999)(20776003)(74662001)(33716001)(54356999)(77982001)(64706001)(86362001)(33656002)(87936001)(31966008)(76482001)(23726002)(46406003)(81342001)(44976005)(46102001)(83322001)(85852003)(19580395003)(102836001)(21056001)(83506001)(4396001)(50466002)(74502001)(81542001)(47776003)(92566001)(26826002)(99396002)(92726001)(79102001)(97756001)(104016001)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB393;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02234DBFF6
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, May 26, 2014 at 03:43:31PM +1000, Stephen Rothwell wrote:
> Hi Daniel,
> 
> Today's linux-next merge of the clockevents tree got a conflict in
> arch/arm/boot/dts/vf610.dtsi between commit 0517fe6aa880 ("ARM: dts:
> vf610-twr: Add support for sdhc1") from the arm-soc tree and commit
> 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer
> node") from the clockevents tree.

Next time, please leave the dts patches to go via arch tree, so that we
can save such conflicts.

Shawn
