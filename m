Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbaLAW4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:56:33 -0500
Received: from mail-bl2on0058.outbound.protection.outlook.com ([65.55.169.58]:2048
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932694AbaLAW4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:56:31 -0500
Date: Mon, 1 Dec 2014 14:56:24 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
 <547CCEE3.6020806@suse.de>
 <fb6f17c51aef4a498eb2a3e01a81df34@BN1BFFO11FD017.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb6f17c51aef4a498eb2a3e01a81df34@BN1BFFO11FD017.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <e016ae7c103a4fbd844826c9e25fe9c2@BY2FFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(51704005)(24454002)(164054003)(189002)(377424004)(64706001)(92566001)(31966008)(77156002)(46102003)(50986999)(6806004)(19580405001)(47776003)(62966003)(50466002)(44976005)(110136001)(77096004)(20776003)(102836001)(54356999)(4396001)(53416004)(120916001)(23676002)(99396003)(95666004)(87936001)(107046002)(74316001)(104016003)(108616004)(19580395003)(86362001)(106466001)(76176999)(85182001)(21056001)(85202003)(83506001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB041;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB041;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB041;
X-Forefront-PRVS: 0412A98A59
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB041;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 01:24PM -0800, Sören Brinkmann wrote:
> On Mon, 2014-12-01 at 09:26PM +0100, Andreas Färber wrote:
> > Hi Sören,
> > 
> > Am 01.12.2014 um 19:42 schrieb Soren Brinkmann:
> > > Add USB nodes to zc702, zc706 and zed device trees.
> > > 
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > ---
> > >  arch/arm/boot/dts/zynq-7000.dtsi | 22 +++++++++++++++++++++-
> > >  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
> > >  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
> > >  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
> > >  4 files changed, 52 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> > > index ce2ef5bec4f2..9ed60938f301 100644
> > > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
[...]
> > > @@ -324,6 +344,6 @@
> > >  			reg = <0xf8005000 0x1000>;
> > >  			reset = <0>;
> > >  			timeout-sec = <10>;
> > > -		};
> > > +		} ;
> > >  	};
> > >  };
> > 
> > Unrelated accidental change here though. :)

Since a v2 is needed now, does this really require a dedicated patch to
fix this bogus space here or do we just look the other way?

	Thanks,
	Sören
