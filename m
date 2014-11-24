Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaKXTcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:32:18 -0500
Received: from mail-bn1bon0089.outbound.protection.outlook.com ([157.56.111.89]:13344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbaKXTcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:32:16 -0500
Date: Mon, 24 Nov 2014 20:31:56 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, <michal.simek@xilinx.com>
CC: <soren.brinkmann@xilinx.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers:block Remove unneeded Fix me message in xsyace.c
References: <1416857108-2618-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1416857108-2618-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21128.001
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <fd1c5863660447cfb2b959e80d42c27c@BN1AFFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(164054003)(199003)(24454002)(377454003)(479174003)(74316001)(62966003)(120916001)(6806004)(31966008)(87936001)(92566001)(33646002)(50986999)(104016003)(95666004)(64126003)(20776003)(46102003)(107046002)(108616004)(99396003)(44976005)(65956001)(21056001)(47776003)(19580405001)(65806001)(54356999)(86362001)(106466001)(4396001)(83506001)(23746002)(77156002)(102836001)(19580395003)(76176999)(50466002)(64706001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB029;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB029;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB029;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB029;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:25 PM, Nicholas Krause wrote:
> Removes unneeded FIXME message related to using a hard coded value for ACE_BUS_WIDTH
> due to it needing to be 8 bits, this is wrong as this function here needs all 16 bits
> of the bus width and not just the lower or higher 16 depending on the machine's bit
> order.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/block/xsysace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index c4328d9..1b807ed 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -1152,7 +1152,7 @@ static void ace_free(struct device *dev)
>  static int ace_probe(struct platform_device *dev)
>  {
>  	resource_size_t physaddr = 0;
> -	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
> +	int bus_width = ACE_BUS_WIDTH_16;
>  	u32 id = dev->id;
>  	int irq = 0;
>  	int i;
> 

Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
