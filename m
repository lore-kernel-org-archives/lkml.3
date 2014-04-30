Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaD3Ghu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:37:50 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:52209
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757457AbaD3Ght (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:37:49 -0400
Date: Wed, 30 Apr 2014 13:39:29 +0800
From: Huang Shijie <b32955@freescale.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        "Shawn Guo" <shawn.guo@freescale.com>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency
 for M25P80)
Message-ID: <20140430053926.GA9673@localhost>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
 <20140429190603.GB9418@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140429190603.GB9418@norris-Latitude-E6410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(24454002)(51704005)(50986999)(97756001)(74662001)(74502001)(76176999)(33656001)(31966008)(1411001)(81542001)(77096999)(54356999)(76482001)(101416001)(33716001)(46406003)(46102001)(80976001)(81342001)(83072002)(99396002)(57986002)(92566001)(92726001)(85852003)(87936001)(50466002)(83506001)(44976005)(83322001)(80022001)(23726002)(6806004)(20776003)(47776003)(79102001)(77982001)(42262001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB339;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0197AFBD92
Authentication-Results: spf=none (sender IP is 192.88.168.1)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 12:06:03PM -0700, Brian Norris wrote:
> OK, I'll try to split it up. Is ARM unique in tracking defconfigs in
> separate trees? I assume MIPS, PowerPC, and Blackfin won't require the
> same splitting? I'd like to avoid 31 patches when <20 could suffice.
> 
> I'll also rebase on linux-next. I think there may be a few conflicts.
Hi Brian:
  If we need to split the patch, please keep the mxs_defconfig and 
  imx_v6_v7_defconfig in a single patch,
  Shawn will review and merge or ack that patch.

  thanks
  Huang Shijie
