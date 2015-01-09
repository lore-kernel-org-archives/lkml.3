Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbbAIPYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:17 -0500
Received: from mail-by2on0080.outbound.protection.outlook.com ([207.46.100.80]:54304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932754AbbAIPYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:12 -0500
Date: Fri, 9 Jan 2015 07:24:07 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RESEND v3] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkda5mAtves=PZibd6jdVP1ztM0EYA+cnw7Gs+mSVXTkqpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda5mAtves=PZibd6jdVP1ztM0EYA+cnw7Gs+mSVXTkqpw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21238.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1bc11e16c89049708a9273d00ac75d2b@BL2FFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(24454002)(189002)(51704005)(377454003)(199003)(108616004)(31966008)(76176999)(110136001)(85182001)(86362001)(47776003)(85202003)(20776003)(104016003)(19580395003)(4396001)(19580405001)(83506001)(74316001)(54356999)(6806004)(50986999)(106466001)(92566001)(53416004)(21056001)(2950100001)(107046002)(87936001)(50466002)(23676002)(46102003)(62966003)(99396003)(120916001)(77156002)(92726002)(107986001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB063;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB063;
X-Forefront-PRVS: 04519BA941
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 15:24:09.1954
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB063
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 10:32AM +0100, Linus Walleij wrote:
> On Mon, Jan 5, 2015 at 7:16 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> > marking/unmarking a GPIO as wake IRQ.
> > The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> > is associated with that GPIO and the irqchip implements set_wake().
> > Writing 'enabled' to that file will enable wake for that GPIO, while
> > writing 'disabled' will disable wake.
> > Reading that file will return either 'disabled' or 'enabled' depening on
> > the currently set flag for the GPIO's IRQ.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> > v3:
> >  - add documentation
> > v2:
> >  - fix error path to unlock mutex before return
> 
> Finally applied for v3.20.
> 
> Sorry for being a bit conservative and picky at times...

Thank you.

	Sören
