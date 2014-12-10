Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaLJJm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:42:57 -0500
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:12016
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752996AbaLJJmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:42:53 -0500
Date: Wed, 10 Dec 2014 10:42:39 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <atull@opensource.altera.com>, <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 4/6] fpga manager: add sysfs interface document
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
 <1418156090-23578-5-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1418156090-23578-5-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21164.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <c234f48c2ff145b4810cef72482bb49c@BL2FFO11FD045.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(24454002)(189002)(479174003)(199003)(377454003)(51704005)(20776003)(77096005)(31966008)(83506001)(86362001)(76176999)(64126003)(108616004)(50986999)(46102003)(106466001)(107046002)(92726002)(65806001)(65956001)(87936001)(92566001)(23746002)(47776003)(64706001)(50466002)(99396003)(54356999)(120916001)(21056001)(104016003)(77156002)(62966003)(4396001)(74316001)(2201001)(6806004)(19580405001)(19580395003)(65826006)(107986001)(24736002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB063;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 12/09/2014 09:14 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add documentation for new fpga manager sysfs interface.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager

What's the rule for adding sysfs doc for driver which is added to staging?
Is this location fine?

Thanks,
Michal

