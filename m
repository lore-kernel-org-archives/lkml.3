Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbaLAXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:16:26 -0500
Received: from mail-bl2on0058.outbound.protection.outlook.com ([65.55.169.58]:7214
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932408AbaLAXQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:16:24 -0500
Date: Mon, 1 Dec 2014 15:16:13 -0800
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
 <e016ae7c103a4fbd844826c9e25fe9c2@BY2FFO11FD036.protection.gbl>
 <547CF650.4070907@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547CF650.4070907@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <ec924523a1e047b59d13a7da868430be@BN1AFFO11FD015.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377424004)(24454002)(189002)(51704005)(23676002)(19580395003)(95666004)(104016003)(19580405001)(47776003)(21056001)(87936001)(92566001)(93886004)(102836001)(106466001)(85202003)(50986999)(76176999)(74316001)(44976005)(86362001)(108616004)(107046002)(4396001)(77156002)(120916001)(64706001)(62966003)(54356999)(33646002)(6806004)(110136001)(31966008)(46102003)(50466002)(99396003)(83506001)(85182001)(53416004)(20776003)(77096004)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB048;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB048;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB048;
X-Forefront-PRVS: 0412A98A59
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB048;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-02 at 12:14AM +0100, Andreas Färber wrote:
> Am 01.12.2014 um 23:56 schrieb Sören Brinkmann:
> > On Mon, 2014-12-01 at 01:24PM -0800, Sören Brinkmann wrote:
> >> On Mon, 2014-12-01 at 09:26PM +0100, Andreas Färber wrote:
> >>> Am 01.12.2014 um 19:42 schrieb Soren Brinkmann:
> >>>> Add USB nodes to zc702, zc706 and zed device trees.
> >>>>
> >>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>>> ---
> >>>>  arch/arm/boot/dts/zynq-7000.dtsi | 22 +++++++++++++++++++++-
> >>>>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
> >>>>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
> >>>>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
> >>>>  4 files changed, 52 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> >>>> index ce2ef5bec4f2..9ed60938f301 100644
> >>>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> >>>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > [...]
> >>>> @@ -324,6 +344,6 @@
> >>>>  			reg = <0xf8005000 0x1000>;
> >>>>  			reset = <0>;
> >>>>  			timeout-sec = <10>;
> >>>> -		};
> >>>> +		} ;
> >>>>  	};
> >>>>  };
> >>>
> >>> Unrelated accidental change here though. :)
> > 
> > Since a v2 is needed now, does this really require a dedicated patch to
> > fix this bogus space here or do we just look the other way?
> 
> Sorry, I don't understand the question: If as you say a v2 is needed,
> why knowingly introduce a space between } and ; in your patch? Maybe I'm
> missing something or you're looking at the patch in reverse...?

Oh, I thought I was removing it... That must have been some merge error.
Forget what I said. This part will vanish.

	Sören
