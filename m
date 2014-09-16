Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaIPBr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:47:28 -0400
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:38571
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753760AbaIPBr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:47:26 -0400
Date: Tue, 16 Sep 2014 09:46:58 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.net>
CC: Fabio Estevam <festevam@gmail.com>, Alexander Shiyan <shc_work@mail.ru>,
        Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, <=devicetree@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 2/4] ARM: dts: pbab01: enable I2S audio
 on phyFLEX-i.MX6 boards
Message-ID: <20140916014657.GB23450@dragon>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410537872-17274-3-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410539161.314611261@f174.i.mail.ru>
 <CAOMZO5C9_XwgcLvVWvxB1A306_Ehm17ZE111j6d+7MhudAhT0g@mail.gmail.com>
 <5416D666.2050302@sam-solutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5416D666.2050302@sam-solutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(479174003)(24454002)(377454003)(189002)(199003)(51704005)(44976005)(83322001)(102836001)(90102001)(106466001)(15975445006)(110136001)(4396001)(6806004)(54356999)(68736004)(105606002)(26826002)(23676002)(19580395003)(4477795004)(19580405001)(46102002)(97736003)(83506001)(107046002)(93886004)(74662001)(74502001)(84676001)(33716001)(64706001)(104016003)(21056001)(87936001)(92726001)(83072002)(85852003)(76482001)(47776003)(20776003)(31966008)(57986006)(95666004)(99396002)(85306004)(50466002)(76176999)(33656002)(50986999)(81542002)(80022002)(81342002)(92566001)(86362001)(77982001)(79102001)(241875001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB264;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:07:02PM +0300, Dmitry Lavnikevich wrote:
> On 12/09/14 19:40, Fabio Estevam wrote:
> >On Fri, Sep 12, 2014 at 1:26 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
> >>Fri, 12 Sep 2014 19:04:30 +0300 от Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>:
> >>>Audio on phyFLEX boards is presented by tlv320aic3007 codec connected
> >>>over SSI interface.
> >>>
> >>>Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> >>>---
> >>...
> >>>+&ssi2 {
> >>>+     fsl,mode = "i2s-slave";
> >>>+     status = "okay";
> >>>+     #sound-dai-cells = <0>;
> >>>+};
> >>I have already sent patch to add "#sound-dai-cells" into all i.MX DT-files.
> >>Shawn, can you point us to this tree/commit?
> >https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/commit/?h=for-next&id=36c7e8826cf32dd4dd34c71b526653b800414355
> So should I base my next patchset on for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git
> ?

Yes, please.

Shawn
