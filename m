Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaLJUt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:49:58 -0500
Received: from mail-bl2on0100.outbound.protection.outlook.com ([65.55.169.100]:29760
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933169AbaLJUt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:49:56 -0500
Date: Wed, 10 Dec 2014 14:49:56 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Greg KH <gregkh@linuxfoundation.org>
CC: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
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
Subject: Re: [PATCH v4 0/6] FPGA Manager Framework
In-Reply-To: <20141210145241.GB17393@kroah.com>
Message-ID: <alpine.DEB.2.02.1412101449200.31575@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <20141210145241.GB17393@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0010.namprd00.prod.outlook.com (25.160.102.20) To
 CY1PR0301MB1244.namprd03.prod.outlook.com (25.161.212.154)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-Forefront-PRVS: 0421BF7135
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(51704005)(199003)(53416004)(31966008)(15975445007)(33716001)(46406003)(110136001)(23726002)(68736005)(42186005)(40100003)(50466002)(122386002)(76176999)(120916001)(99396003)(77156002)(97736003)(62966003)(19580405001)(69596002)(101416001)(21056001)(105586002)(92566001)(4396001)(87976001)(107046002)(86152002)(66066001)(81156004)(50986999)(54356999)(106356001)(46102003)(64706001)(20776003)(86362001)(47776003)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1244;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Greg KH wrote:

> On Tue, Dec 09, 2014 at 02:14:44PM -0600, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Improvements in this v3 and v4:
> 
> Due to the review comments here, and all of the kbuild issues found,
> please just work on a v5 series that I can apply after 3.19-rc1 is out.
> I'm dropping this series from my queue now because of those issues.

That sounds great.

Thank you,

Alan


> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
