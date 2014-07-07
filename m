Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaGGRfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:35:38 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:11911
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750809AbaGGRfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:35:32 -0400
Date: Mon, 7 Jul 2014 10:35:02 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Harini Katakam <harinik@xilinx.com>, Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harini.katakam@xilinx.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add Zynq GPIO devicetree bindings
 documentation
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <1403091577-10232-2-git-send-email-harinik@xilinx.com>
 <CACRpkdYZ8gQ_-z3Ue3WZZ4FiV8dhw_BZez2-PLpeiBTs-UnNFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYZ8gQ_-z3Ue3WZZ4FiV8dhw_BZez2-PLpeiBTs-UnNFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <30b61880-97a0-4e94-a71e-d738f0416d9d@BN1BFFO11FD056.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377454003)(199002)(189002)(24454002)(51704005)(377424004)(54356999)(83506001)(76176999)(1496007)(92726001)(102836001)(31696002)(85852003)(83072002)(77982001)(92566001)(74662001)(74502001)(74316001)(31966008)(86362001)(99396002)(50986999)(64706001)(19580395003)(33646001)(44976005)(6806004)(79102001)(87936001)(20776003)(47776003)(19580405001)(83322001)(81542001)(70736001)(81342001)(85202003)(106466001)(85182001)(77096002)(4396001)(50466002)(80022001)(46102001)(23676002)(76482001)(95666004)(104016002)(85306003)(21056001)(107046002)(110136001)(53416004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB004;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 04:53PM +0200, Linus Walleij wrote:
> On Wed, Jun 18, 2014 at 1:39 PM, Harini Katakam <harinik@xilinx.com> wrote:
> 
> > From: Harini Katakam <harini.katakam@xilinx.com>
> >
> > Add gpio-zynq bindings documentation.
> >
> > Signed-off-by: Harini Katakam <harinik@xilinx.com>
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >
> > v2 changes:
> > Improve description.
> (...)
> > +- #gpio-cells          : Should be two. First cell is used to mention
> > +                         pin number.
> 
> Don't call this "pin number", call it "GPIO line number".
It's also not mentioning the second cell at all. I'll take the part from
gpio-msm to document this property and replace 'pin' with 'GPIO line'.

	Sören

