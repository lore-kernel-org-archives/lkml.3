Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaDYFo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:44:26 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:44644
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751640AbaDYFoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:44:23 -0400
Date: Fri, 25 Apr 2014 12:47:04 +0800
From: Huang Shijie <b32955@freescale.com>
To: Graham Moore <ggrahammoore@gmail.com>
CC: Marek Vasut <marex@denx.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Insop Song <insop.song@gainspeed.com>,
        Graham Moore <grmoore@altera.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, <linux-kernel@vger.kernel.org>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron
 chips.
Message-ID: <20140425044703.GD24530@localhost>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
 <1398175396-7560-2-git-send-email-grmoore@altera.com>
 <201404221855.57247.marex@denx.de>
 <CA+iBjpR=CYd5JRs6u+BCbqicjoMqRwFRFRS7OFxOrYjetg5mgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+iBjpR=CYd5JRs6u+BCbqicjoMqRwFRFRS7OFxOrYjetg5mgQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(24454002)(377454003)(51704005)(23726002)(50986999)(74502001)(31966008)(4396001)(46102001)(33716001)(77096999)(76176999)(81342001)(33656001)(74662001)(81542001)(50466002)(99396002)(46406003)(1411001)(85852003)(57986002)(83506001)(80976001)(6806004)(80022001)(79102001)(92726001)(83072002)(87936001)(92566001)(19580395003)(44976005)(19580405001)(77982001)(47776003)(97756001)(20776003)(54356999)(83322001)(76482001)(42262001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB029;H:az84smr01.freescale.net;FPR:1093F4C5.89A06C45.BBFF8677.D7AA9BA3.2014E;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0192E812EC
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:48:21PM -0500, Graham Moore wrote:
> On Tue, Apr 22, 2014 at 11:55 AM, Marek Vasut <marex@denx.de> wrote:
> > Are you sure the n25q512a doesn't use FSR ? Do n25q512a{1,8}3 share the same
> > IDs?
> 
> I looked at the datasheet and the n25q512a *does* have the same FSR
> usage note, so I suppose I should add USE_FSR to it as well.  But how
> is it working now?  Maybe nobody is actually using that chip.
> Yes, n25q512a{1,8}3 share the same id, 0x20ba20.
> 
could use the ext_id to distinguish them ? just as we did for Spansion NOR.

i dumped out 5 bytes of my n25q256a: 0x20, 0xba, 0x19, 0x10, 0x00.

thanks
Huang Shijie
