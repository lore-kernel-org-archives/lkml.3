Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaDNVjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:39:36 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:4193
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755689AbaDNVje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:39:34 -0400
Date: Mon, 14 Apr 2014 14:38:53 -0700
From: Insop Song <insop.song@gainspeed.com>
To: Mark Brown <broonie@kernel.org>
CC: Jane Wan <Jane.Wan@gainspeed.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <Emilian.Medve@Freescale.com>,
        <kenth.eriksson@transmode.com>, <thomas.de.schampheleire@gmail.com>,
        <b48286@Freescale.com>, <jg1.han@samsung.com>, <sr@denx.de>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
Message-ID: <20140414213853.GF14129@neon.local.cohere.net>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <20140414205151.GH25182@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140414205151.GH25182@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [157.56.236.5]
X-ClientProxiedBy: BY2PR07CA026.namprd07.prod.outlook.com (10.141.216.41) To
 BY2PR07MB011.namprd07.prod.outlook.com (10.255.241.37)
X-Forefront-PRVS: 0181F4652A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(54534003)(51704005)(199002)(189002)(74662001)(79102001)(42186004)(31966008)(77982001)(86362001)(87976001)(74502001)(4396001)(99396002)(66066001)(80022001)(80976001)(83322001)(19580395003)(46102001)(47776003)(20776003)(81342001)(92726001)(23726002)(33656001)(54356999)(76176999)(92566001)(97756001)(50986999)(50466002)(83072002)(85852003)(81542001)(83506001)(46406003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB011;H:BY2PRD0310HT003.namprd03.prod.outlook.com;FPR:ECDAF4D1.ACE01729.31DCA778.C442F9E9.201DE;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:51:51PM +0100, Mark Brown wrote:
> On Sat, Apr 12, 2014 at 11:48:35AM -0700, Jane Wan wrote:
> > Make FSL eSPI properties configurable through device tree.  The
> > configurable parameters include CSnBEF and CSnAFT in ESPI_SPMODEn
> > registers (n=0,1,2,3), and whether to send all received data to user.
> 
> Don't send cover letters for individual patches, include anything that's
> needed in the patch changelog or after the ---.
> 
> > Test done:
> > - Kernel version 3.8.13
> 
> We're developing v3.15 now, you need to submit against current code.
> 

We will generate a new patch.

> Please also be sure to CC the mailing list on patches, the sourceforge
> list has been unused for quite some time now.

We use scripts/get_maintainer.pl to get the mailing addresses.
We will double check the mailing list from MAINTAINER file.

Regards,

Insop

