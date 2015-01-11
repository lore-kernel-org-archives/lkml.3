Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbbAKXB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:01:58 -0500
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:22464
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750887AbbAKXB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:01:56 -0500
Date: Sun, 11 Jan 2015 15:01:47 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] pinctrl support for Zynq
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
 <b987f31220ab424285e27200bb187158@BY2FFO11FD012.protection.gbl>
 <CACRpkdYLHOHhSYSJZcggmATnMRg_7Pq8-fF3c2MJW9E69DiqJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYLHOHhSYSJZcggmATnMRg_7Pq8-fF3c2MJW9E69DiqJg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <8b127d21cad948daafffcc449cd92e4b@BL2FFO11FD014.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(51704005)(377424004)(199003)(164054003)(377454003)(189002)(85202003)(50466002)(110136001)(54356999)(83506001)(85182001)(50986999)(106466001)(19580405001)(19580395003)(6806004)(87936001)(104016003)(74316001)(47776003)(64706001)(46102003)(76176999)(53416004)(77156002)(86362001)(108616004)(92726002)(23676002)(92566002)(2950100001)(62966003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB009;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB009;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB009;
X-Forefront-PRVS: 045315E1EE
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB009;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 23:01:54.1015
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 10:41PM +0100, Linus Walleij wrote:
> On Fri, Jan 9, 2015 at 5:53 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > On Fri, 2015-01-09 at 07:43AM -0800, Soren Brinkmann wrote:
> >> Hi Linus,
> >>
> >> I rebased my branch onto your current pinctrl/devel. Other than that
> >> this should be exactly what has been sent out as v3. This time I'll use
> >> the gmail SMTP again, which hopefully resolves the encoding issue.
> >
> > The transfer-encoding is again 'quoted-printable'. So, seems it is not
> > exchange to blame. I tried to git am a patch from this series and it
> > seems to work fine. I.e. send-email and am apparently to the right
> > thing.
> 
> Yeah it works like a charm :)
> 
> All patches that affect the pin control tree are applied now. It is
> looking *beautiful* especially your device trees look exactly as I
> want them to look for a group/function type pin controller driver.

Thanks a lot! This is great.

@Michal: Could you please pick up the patches that go through the armsoc
tree (5 and 6 in this series)?

	Thanks,
	Sören
