Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbaLDR21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:28:27 -0500
Received: from mail-bn1bon0066.outbound.protection.outlook.com ([157.56.111.66]:3645
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932219AbaLDR2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:28:25 -0500
Date: Thu, 4 Dec 2014 09:28:17 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: Re: [PATCH v2 0/7] Pinctrl support for Zynq
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdbYPmMksbqciiXv4hHBqx9=b8toA5MgCwGSLteUh+NkZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbYPmMksbqciiXv4hHBqx9=b8toA5MgCwGSLteUh+NkZA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21150.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <053edb05cd874daf9232cd5e4930df92@BN1BFFO11FD042.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(54534003)(51704005)(377454003)(24454002)(199003)(377424004)(189002)(120916001)(99396003)(74316001)(83506001)(47776003)(85202003)(92726002)(46102003)(4396001)(92566001)(86362001)(19580405001)(85182001)(21056001)(6806004)(50986999)(53416004)(50466002)(107046002)(77156002)(62966003)(110136001)(104016003)(87936001)(54356999)(23676002)(64706001)(108616004)(33646002)(76176999)(31966008)(19580395003)(106466001)(20776003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB040;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB040;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB040;
X-Forefront-PRVS: 041517DFAB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB040;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, 2014-12-04 at 10:44AM +0100, Linus Walleij wrote:
> On Fri, Nov 28, 2014 at 2:26 AM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > here is v2 of this series. On the functional side, adding the support
> > for USB mux groups is probably the biggest change. Most other changes
> > are mostly cosmetic (typos, function names, documentation, ...).
> > More detailed changelogs are included with the respective patches.
> 
> Unfortunately we are late in the merge cycle.
> 
> But I am *very* fond of this series, and I appreciate your patches
> as *lot* Sören.
> 
> So my plan is to merge your v3 patch set after the merge window
> or whenever you have it ready, with the Zynq driver on top and
> the dependent AMlogic driver too.
> 
> Then we spend the next kernel cycle hashing this out and
> putting some polished generic code in place so we get some
> order.
> 
> This will likely set the pattern for how we expect ACPI pin controllers
> to behave too, so it is work of great importance.
> 
> I hope I can count on you to hang in there and keep driving
> those patches!
> 
> I'll try to provide a deeper look at the indivudual patches now.

Sounds great! After bringing it so far, I wasn't planning of giving up
now :)

The approach you chose sounds good to me. I was currently waiting to see
whether there are a few more change requests coming before sending v3.
The few comments that came in so far I have already fixed up. Since it's
not going to make it into this merge window there may be some more time
now, but in general, I could send v3 any time.

	Sören
