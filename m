Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaKXTeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:34:07 -0500
Received: from mail-bn1on0065.outbound.protection.outlook.com ([157.56.110.65]:24954
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752643AbaKXTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:34:05 -0500
Date: Mon, 24 Nov 2014 11:33:57 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Nicholas Krause <xerofoify@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers:block Remove unneeded Fix me message in xsyace.c
References: <1416857108-2618-1-git-send-email-xerofoify@gmail.com>
 <fd1c5863660447cfb2b959e80d42c27c@BN1AFFO11FD018.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd1c5863660447cfb2b959e80d42c27c@BN1AFFO11FD018.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21128.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <08ea34761ecd4d5a8bc814d1d42c9b61@BN1AFFO11FD048.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(479174003)(51704005)(377454003)(189002)(24454002)(377424004)(20776003)(76176999)(64706001)(6806004)(44976005)(19580395003)(74316001)(47776003)(110136001)(120916001)(85182001)(46102003)(95666004)(19580405001)(23676002)(104016003)(92566001)(106466001)(102836001)(85202003)(33646002)(54356999)(50466002)(77156002)(87936001)(62966003)(107046002)(108616004)(86362001)(31966008)(53416004)(4396001)(50986999)(83506001)(21056001)(99396003)(77096003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB034;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB034;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB034;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB034;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 08:31PM +0100, Michal Simek wrote:
> On 11/24/2014 08:25 PM, Nicholas Krause wrote:
> > Removes unneeded FIXME message related to using a hard coded value for ACE_BUS_WIDTH
> > due to it needing to be 8 bits, this is wrong as this function here needs all 16 bits
> > of the bus width and not just the lower or higher 16 depending on the machine's bit
> > order.
> > 
> > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> > ---
> >  drivers/block/xsysace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> > index c4328d9..1b807ed 100644
> > --- a/drivers/block/xsysace.c
> > +++ b/drivers/block/xsysace.c
> > @@ -1152,7 +1152,7 @@ static void ace_free(struct device *dev)
> >  static int ace_probe(struct platform_device *dev)
> >  {
> >  	resource_size_t physaddr = 0;
> > -	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
> > +	int bus_width = ACE_BUS_WIDTH_16;
> >  	u32 id = dev->id;
> >  	int irq = 0;
> >  	int i;
> > 
> 
> Reviewed-by: Michal Simek <michal.simek@xilinx.com>

I find the commit message rather misleading, but the change is OK.

	Sören
