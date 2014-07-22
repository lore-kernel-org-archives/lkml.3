Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaGVPhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:37:08 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:28007
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbaGVPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:37:07 -0400
Message-ID: <1406043245.5571.4.camel@linux-builds1>
Subject: Re: [PATCH 0/3] clk : Fix SOCFPGA clk crash and some clean up
From: Dinh Nguyen <dinguyen@altera.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Charles Manning <cdhmanning@gmail.com>, <linux-kernel@vger.kernel.org>,
        Chin Liang See <clsee@altera.com>
Date: Tue, 22 Jul 2014 10:34:05 -0500
In-Reply-To: <738unmvspk.fsf@unicorn.hi.pengutronix.de>
References: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
	 <738unmvspk.fsf@unicorn.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(377424004)(199002)(164054003)(24454002)(95666004)(88136002)(4396001)(103116003)(74502001)(23676002)(97736001)(92726001)(83322001)(92566001)(77096002)(84676001)(93916002)(87286001)(81542001)(50986999)(104166001)(31966008)(33716001)(85852003)(102836001)(16796002)(87936001)(77982001)(68736004)(20776003)(44976005)(47776003)(21056001)(19580395003)(62966002)(89996001)(105596002)(99396002)(50226001)(76176999)(74662001)(107046002)(110136001)(79102001)(81342001)(77156001)(83072002)(19580405001)(46102001)(80022001)(106466001)(76482001)(6806004)(33646002)(64706001)(50466002)(85306003)(86362001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB038;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:3;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=dinguyen@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On Tue, 2014-07-22 at 08:00 +0200, Steffen Trumtrar wrote:
> Hi!
> 
> As you touch clk.c, you should Cc
> 
>    Mike Turquette <mturquette@linaro.org>
> 
> He is the maintainer for that code.
> 

Yes, please use get_maintainer.pl on any files that you have a patch
for.

./scripts/get_maintainer.pl -f drivers/clk/socfpga/clk.c
Dinh Nguyen <dinguyen@altera.com> (maintainer:ARM/SOCFPGA CLOCK...)
Mike Turquette <mturquette@linaro.org> (maintainer:COMMON CLK FRAMEWORK)
linux-kernel@vger.kernel.org (open list:COMMON CLK FRAMEWORK)

Thanks,
Dinh
> Regards,
> Steffen
> 


