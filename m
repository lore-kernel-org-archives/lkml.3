Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaFGSW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 14:22:27 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:10533
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752893AbaFGSW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 14:22:26 -0400
Date: Sat, 7 Jun 2014 20:22:06 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/2] ARM: zynq: DT: Add XADC node
References: <1401984324-6075-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1401984324-6075-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <14b7ff93-2553-456f-9cb8-11e2dcd399c8@BN1BFFO11FD053.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(164054003)(377454003)(479174003)(51704005)(24454002)(189002)(199002)(92726001)(92566001)(86362001)(70736001)(102836001)(50986999)(1496006)(99396002)(85852003)(83072002)(21056001)(54356999)(81342001)(76176999)(77096999)(31966008)(74502001)(50466002)(33646001)(74316001)(87936001)(19580405001)(83322001)(83506001)(19580395003)(46102001)(76482001)(4396001)(6806004)(80022001)(81542001)(65956001)(20776003)(104016001)(31696002)(47776003)(79102001)(77982001)(64126003)(64706001)(23756003)(44976005)(65826006);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB025;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0235CBE7D0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 06:05 PM, Soren Brinkmann wrote:
> Add node for the Xilinx A/D Converter.
> 
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied to zynq/dt branch.

Thanks,
Michal


