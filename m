Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147AbaGXXJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:09:36 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:10645
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932521AbaGXXJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:09:33 -0400
Date: Thu, 24 Jul 2014 16:09:23 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406242820-20140-5-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <82ab6426-211e-451e-99c3-df40dbea817e@BN1AFFO11FD039.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(377424004)(24454002)(77096002)(6806004)(46102001)(85306003)(44976005)(83322001)(95666004)(85202003)(106466001)(104016003)(23676002)(21056001)(558084003)(110136001)(81542001)(1496007)(79102001)(76482001)(4396001)(74662001)(80022001)(85852003)(83072002)(31696002)(74502001)(50466002)(31966008)(20776003)(81342001)(64706001)(77982001)(33646002)(102836001)(70736001)(107046002)(53416004)(86362001)(50986999)(92566001)(74316001)(92726001)(87936001)(99396002)(76176999)(54356999)(83506001)(85182001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB006;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
> Avoids deprecation warning messages.

A patch that updates those names is already in armsoc.

	Sören

