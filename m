Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaKQS5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:57:52 -0500
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:34432
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751547AbaKQS5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:57:50 -0500
Date: Mon, 17 Nov 2014 10:57:45 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Beniamino Galvani <b.galvani@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, Carlo Caione <carlo@caione.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v3 0/3] Amlogic Meson pinctrl driver
References: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21110.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <7d408e1ab6ad46b9ba9010dd18b0df54@BY2FFO11FD038.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(164054003)(24454002)(199003)(51704005)(377424004)(108616004)(104016003)(86362001)(107046002)(120916001)(99396003)(21056001)(102836001)(6806004)(53416004)(44976005)(77096003)(4396001)(23676002)(74316001)(110136001)(31966008)(62966003)(92566001)(50986999)(76176999)(46102003)(77156002)(85202003)(83506001)(20776003)(85182001)(47776003)(54356999)(50466002)(87936001)(95666004)(64706001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB053;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB053;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB053;
X-Forefront-PRVS: 03982FDC1D
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB053;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Beniamino,

On Sun, 2014-11-16 at 09:14PM +0100, Beniamino Galvani wrote:
> Hi,
> 
> this is the third version of the pinctrl driver for Amlogic Meson. It
> provides a common infrastructure than can be used by all the SoCs of
> the family and configuration data specific for Meson8. Adding support
> for other SoCs should be only matter of defining new pins and banks.
> 
> The driver uses generic DT properties for the definition of mux and
> configuration nodes; since there is an ongoing effort to centralize
> the parsing to generic code, I've reused the patch "pinctrl:
> pinconf-generic: Infer map type from DT property" [1] posted a few
> days ago by Soren Brinkmann. I will update the series if that patch is
> going to change after the mailing list discussion.

Looks really nice to me and it's great that you use my patch as basis.
Looks like it works for more people than just me :)
I hope we can convince Linus to take that patch more or less as is. Even
though "kludgy" I don't see an easy way for addressing Linus' comments
without breaking current users of the interface. It may be easier/better
to gradually migrate to the newly defined bindings and remove the
kludgyness as user that rely on the current behavior disappear.

	Thanks,
	Sören
