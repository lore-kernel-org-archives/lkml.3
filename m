Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbbAIPZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:25:18 -0500
Received: from mail-by2on0066.outbound.protection.outlook.com ([207.46.100.66]:1472
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933016AbbAIPZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:25:12 -0500
Date: Fri, 9 Jan 2015 07:25:02 -0800
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
Subject: Re: [PATCH v3 0/7] Pinctrl support for Zynq
References: <1d59c0972da04ec89dec6c09724986a1@BY2FFO11FD010.protection.gbl>
 <4d544fe425694a4e8043ddbf604db062@BN1AFFO11FD033.protection.gbl>
 <CACRpkdaKH21qz_RAcDtw6ycsw+5FD0RXQQs91_tZV53EuKVusQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaKH21qz_RAcDtw6ycsw+5FD0RXQQs91_tZV53EuKVusQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21238.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <ba4ac5f77c7549f2a264a5a5b1318dc8@BN1BFFO11FD009.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=temperror (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(199003)(377424004)(377454003)(189002)(164054003)(24454002)(50986999)(74316001)(120916001)(76176999)(87936001)(54356999)(85182001)(19580395003)(50466002)(21056001)(83506001)(19580405001)(2950100001)(77156002)(110136001)(92566001)(46102003)(53416004)(106466001)(23676002)(85202003)(104016003)(4396001)(33646002)(107046002)(20776003)(86362001)(47776003)(62966003)(6806004)(92726002)(108616004)(99396003)(31966008)(107986001)(24736002)(299355004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB010;H:xsj-pvapsmtpgw01;FPR:;SPF:TempError;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB010;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB010;
X-Forefront-PRVS: 04519BA941
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB010;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 15:25:07.3336
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 09:45AM +0100, Linus Walleij wrote:
> On Fri, Dec 12, 2014 at 5:37 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Argh, this went through the wrong SMTP. I suspect threading is broken
> > due to that. Let me know if you want me to resend this with intact
> > threading.
> 
> I don't care much about the threading, but all messages are quoted-printable
> which doesn't apply :(
> 
> i.e.:
> 
> Content-Transfer-Encoding: quoted-printable
> (...)
> 
> + const char *subnode_target_type =3D "pins";
> =20
> (...)
> 
> Can you resent with more sane encoding? I don't know where this
> comes from but suspect the Microsoft Exchange SMTP server
> does this when you use diacritics and german letters...

Okay, I'll rebase to the latest pinctrl/devel branch (if needed) and
send an updated version bypassing exchange. I hope that works then.

	Thanks,
	Sören
