Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbaDOACB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:02:01 -0400
Received: from [207.46.163.204] ([207.46.163.204]:44040 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753593AbaDOAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:01:58 -0400
Date: Mon, 14 Apr 2014 16:59:11 -0700
From: Insop Song <insop.song@gainspeed.com>
To: Mark Brown <broonie@kernel.org>
CC: Jane Wan <Jane.Wan@gainspeed.com>, <grant.likely@secretlab.ca>,
        <Emilian.Medve@Freescale.com>, <kenth.eriksson@transmode.com>,
        <thomas.de.schampheleire@gmail.com>, <b48286@Freescale.com>,
        <jg1.han@samsung.com>, <sr@denx.de>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
Message-ID: <20140414235911.GA16287@neon.local.cohere.net>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <20140414205151.GH25182@sirena.org.uk>
 <20140414213853.GF14129@neon.local.cohere.net>
 <20140414234949.GH12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140414234949.GH12304@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [157.56.236.5]
X-ClientProxiedBy: BY2PR07CA022.namprd07.prod.outlook.com (10.255.247.47) To
 BY2PR07MB009.namprd07.prod.outlook.com (10.255.241.35)
X-Forefront-PRVS: 0181F4652A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(24454002)(51704005)(46406003)(97756001)(42186004)(33656001)(81342001)(19580395003)(83322001)(83072002)(85852003)(87976001)(74502001)(74662001)(31966008)(80976001)(4396001)(23726002)(83506001)(46102001)(66066001)(80022001)(20776003)(47776003)(99396002)(50466002)(86362001)(92726001)(92566001)(79102001)(77982001)(76176999)(54356999)(50986999)(81542001)(98436001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB009;H:BY2PRD0310HT004.namprd03.prod.outlook.com;FPR:EBFFF48D.A8E21FA1.31D4A7FC.CDDFF8.201B7;MLV:nov;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:49:49AM +0100, Mark Brown wrote:
> On Mon, Apr 14, 2014 at 02:38:53PM -0700, Insop Song wrote:
> > On Mon, Apr 14, 2014 at 09:51:51PM +0100, Mark Brown wrote:
> 
> > > Please also be sure to CC the mailing list on patches, the sourceforge
> > > list has been unused for quite some time now.
> 
> > We use scripts/get_maintainer.pl to get the mailing addresses.
> > We will double check the mailing list from MAINTAINER file.
> 
> This will be part of not using a current kernel - if you're using a v3.8
> kernel to check then that's over a year out of date.

Mark,

If you were asking that the issue is due to the fact that the kernel we are using is
out of date, then here is our response.

Though, we didn't generate the patch with the latest kernel, we HAVE checked the
latest kernel and the *bugginess* of the freescale espi driver was the same as
the kernel that we are using.

Using the other thread, we will response to your other concerns.

Regards,

Insop
