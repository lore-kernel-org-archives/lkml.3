Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaKXHsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:48:15 -0500
Received: from mail-bn1bon0059.outbound.protection.outlook.com ([157.56.111.59]:5856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbaKXHsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:48:13 -0500
Date: Mon, 24 Nov 2014 08:47:54 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, <michal.simek@xilinx.com>
CC: <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: FIX ME in xsysace.c
References: <5472B1D6.7080805@gmail.com>
In-Reply-To: <5472B1D6.7080805@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21124.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <5a8be93a4204429daf16bc8f62cdd0cd@BY2FFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(164054003)(52044002)(199003)(24454002)(479174003)(377454003)(107046002)(77156002)(76176999)(47776003)(120916001)(65956001)(31966008)(50466002)(54356999)(4396001)(108616004)(50986999)(104016003)(62966003)(46102003)(95666004)(83506001)(74316001)(86362001)(64706001)(92566001)(21056001)(23676002)(99396003)(87936001)(102836001)(6806004)(44976005)(20776003)(106466001)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB006;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB006;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB006;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB006;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/24/2014 05:19 AM, nick wrote:
> Greetings Michal and others,
> I am wondering about the FIX ME in xsysace.c as it seems not correct due to my knowledge of most hardware protocols using a predetermined bit wide and therefore this could be hard coded. If someone can respond on if I am correct in removing this fix me it would be greatly appreciated.

I think that will be the best to c&p that fixme which you are talking about.
Definitely feel free to fix whatever fixme is there and send the patch
for fixing it.

Thanks,
Michal

