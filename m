Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbaGRJvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:51:45 -0400
Received: from [207.46.163.243] ([207.46.163.243]:42770 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934416AbaGRJvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:51:38 -0400
Date: Fri, 18 Jul 2014 11:51:21 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] ARM: zynq: dt: Add GPIO node
References: <1405018418-23396-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1405018418-23396-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
Message-ID: <f27926ad-5c25-405a-a461-6d7ec7be628b@BL2FFO11FD054.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(377454003)(24454002)(479174003)(199002)(189002)(51704005)(99396002)(83322001)(46102001)(44976005)(54356999)(4396001)(21056001)(77982001)(95666004)(74316001)(87936001)(47776003)(31696002)(50466002)(19580405001)(6806004)(19580395003)(107046002)(104016003)(81542001)(50986999)(106466001)(102836001)(1496007)(85306003)(92566001)(81342001)(79102001)(31966008)(85852003)(74502001)(80022001)(74662001)(70736001)(83072002)(76482001)(92726001)(65956001)(20776003)(23676002)(86362001)(76176999)(64706001)(83506001)(65826006)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB065;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02760F0D1C
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 08:53 PM, Soren Brinkmann wrote:
> Add node describing Zynq's GPIO controller.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> The GPIO driver and binding documentation is staged in Linus' GPIO tree.
> 
> 	Sören
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Applied for zynq dt-next when gpio driver is in mainline.

Thanks,
Michal


