Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216AbaGXXZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:25:00 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:48728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932131AbaGXXY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:24:58 -0400
Date: Thu, 24 Jul 2014 16:24:49 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 04/11] ARM: dts: zynq: Update deprecated xuartps clock
 names
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-5-git-send-email-afaerber@suse.de>
 <82ab6426-211e-451e-99c3-df40dbea817e@BN1AFFO11FD039.protection.gbl>
 <53D1931C.7080409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D1931C.7080409@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <50aad941-92d9-428a-a708-77040e24b651@BY2FFO11FD008.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(189002)(24454002)(51704005)(199002)(31966008)(106466001)(81342001)(110136001)(83322001)(81542001)(85202003)(85306003)(107046002)(6806004)(77096002)(92726001)(74502001)(102836001)(83506001)(54356999)(53416004)(99396002)(50986999)(76176999)(21056001)(95666004)(80022001)(20776003)(50466002)(74662001)(46102001)(31696002)(64706001)(1496007)(86362001)(74316001)(79102001)(93886003)(4396001)(23676002)(70736001)(85852003)(44976005)(92566001)(83072002)(87936001)(104016003)(77982001)(76482001)(85182001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB048;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 01:13AM +0200, Andreas Färber wrote:
> Am 25.07.2014 01:09, schrieb Sören Brinkmann:
> > On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
> >> Avoids deprecation warning messages.
> > 
> > A patch that updates those names is already in armsoc.
> 
> Which tree/branch should I base this series on then? It seemed the
> Xilinx branches were all heavily outdated some days ago, so this is
> against vanilla v3.16-rc6.

That is something for the maintainers to answer. But in general, you're
adding a lot of stuff that is not yet upstream, AFAIK. Some is still
under review I think (like QSPI), others are just staged for the next
merge window and parts are still in flight. Michal hopefully has a
better overview.
This particular patch can simply be omitted I think.

	Sören

