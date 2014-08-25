Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaHYOmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:42:15 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:49356
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932490AbaHYOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:42:13 -0400
Date: Mon, 25 Aug 2014 07:42:07 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Olof Johansson <olof@lixom.net>
CC: Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 00/11] ARM: multi_v7_defconfig: Enable Zynq/Xilinx drivers
References: <1408722876-7791-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140823041734.GA11268@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140823041734.GA11268@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20902.005
X-TM-AS-Result: No--22.274-5.0-31-1
X-imss-scan-details: No--22.274-5.0-31-1
Message-ID: <09383930-0cc9-490e-be4e-e45cc9a31041@BN1BFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(52604005)(164054003)(51704005)(24454002)(377424004)(189002)(199003)(21056001)(31966008)(74316001)(20776003)(76176999)(104016003)(81342001)(80022001)(106466001)(79102001)(4396001)(107046002)(81542001)(85182001)(110136001)(33646002)(85306004)(64706001)(47776003)(83072002)(90102001)(70736001)(83506001)(74662001)(1496007)(54356999)(77096002)(102836001)(50986999)(23676002)(6806004)(99396002)(85852003)(76482001)(31696002)(74502001)(92566001)(46102001)(95666004)(44976005)(85202003)(50466002)(86362001)(87936001)(83322001)(77982001)(92726001)(53416004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB033;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 09:17PM -0700, Olof Johansson wrote:
> On Fri, Aug 22, 2014 at 08:54:25AM -0700, Soren Brinkmann wrote:
> > Hi,
> > 
> > I went through the defconfig and searched for Zynq drivers. The result is
> > this series of patches. The first few are all for Zynq and pretty much
> > straight forward. The second half is mostly soft-IP, I think. That
> > soft-IP works with Zynq devices, but I'm not sure whether those should
> > go into the multi_v7 defconfig.
> 
> Thanks, SÃren! 
> 
> There's no need to split up into individual patches like this, but it was
> convenient in case I wanted to only apply a few of them. I took them all
> as one patch, and used your series description as commit message since
> none of the individual patches had any. :)

Yeah, that was my thinking. It's easier to squash things than splitting.
Thanks for taking it.

> 
> As far as "unusual" drivers in the multiconfig; yeah, we need to deal
> with that at some point due to kernel size. We're likely to switch ti
> using modules first, but it'll make things slightly more complicated
> since people will need to start dealing with initrds and at least I
> don't have a good setup for that in my test farm yet. :-)

I agree. Monolithic kernels make those things a lot easier.

	Thanks,
	Sören
