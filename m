Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbbAOQhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:37:42 -0500
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:60592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbbAOQhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:37:41 -0500
Date: Thu, 15 Jan 2015 08:37:36 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Johan Hovold <johan@kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RESEND v3] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1420481779-22841-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdYJ_kZw3UfYc5vGd0cxwDJD5WR69c6Q5xTvmFnb7NOfkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYJ_kZw3UfYc5vGd0cxwDJD5WR69c6Q5xTvmFnb7NOfkA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21254.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <3ac0072cbc4a4efaa7eaf071bbc321a1@BL2FFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(189002)(24454002)(377424004)(199003)(377454003)(85182001)(87936001)(50986999)(54356999)(76176999)(46102003)(64706001)(86362001)(77156002)(62966003)(53416004)(92566002)(23676002)(2950100001)(19580405001)(19580395003)(6806004)(106466001)(74316001)(108616004)(104016003)(85202003)(83506001)(47776003)(92726002)(50466002)(110136001)(107986001)(24736002)(23106004)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB009;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB009;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB009;
X-Forefront-PRVS: 0457F11EAF
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB009;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2015 16:37:39.1501
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 05:34PM +0100, Linus Walleij wrote:
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
> 
> As per discussion with Johan Hovold I have had to remove this patch
> from the development tree.
> 
> Please rebase as indicated on the "fixes" branch, fix any resource
> leaks, include Johan Hovold on CC for review and resend.

Is that public somewhere? What are the issues?

	Sören
