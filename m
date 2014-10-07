Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaJGAYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:24:22 -0400
Received: from mail-bn1bon0112.outbound.protection.outlook.com ([157.56.111.112]:19607
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751720AbaJGAYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:24:21 -0400
Message-ID: <1412641450.13320.509.camel@snotra.buserror.net>
Subject: Re: [PATCH v2 2/2] spi: fsl-spi: Allow dynamic allocation of CPM1
 parameter RAM
From: Scott Wood <scottwood@freescale.com>
To: christophe leroy <christophe.leroy@c-s.fr>
CC: Mark Brown <broonie@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>
Date: Mon, 6 Oct 2014 19:24:10 -0500
In-Reply-To: <542FC6CC.4000507@c-s.fr>
References: <20141003164917.397871AB276@localhost.localdomain>
	 <1412365908.13320.429.camel@snotra.buserror.net> <542FC6CC.4000507@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:6d45:e00c:643e:3f23]
X-ClientProxiedBy: BLUPR01CA025.prod.exchangelabs.com (25.160.23.15) To
 DM2PR0301MB0733.namprd03.prod.outlook.com (25.160.97.141)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0733;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377424004)(199003)(24454002)(50226001)(4396001)(99396003)(92726001)(110136001)(86362001)(120916001)(33646002)(97736003)(85306004)(107046002)(46102003)(76482002)(77096002)(106356001)(105586002)(40100002)(19580395003)(50466002)(50986999)(80022003)(47776003)(76176999)(101416001)(92566001)(10300001)(95666004)(31966008)(104166001)(102836001)(42186005)(88136002)(103116003)(87286001)(87976001)(21056001)(85852003)(20776003)(93916002)(77156001)(89996001)(23676002)(122386002)(62966002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0733;H:[IPv6:2601:2:5800:3f7:6d45:e00c:643e:3f23];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-04 at 12:07 +0200, christophe leroy wrote:
> The bindings for that driver are described in 
> Documentation/devicetree/bindings/spi/fsl-spi.txt. But it seems that it 
> doesn't describe anything related to those compatibles. The driver has a 
> match on "fsl,fsl-spi" only,

I think you mean "fsl,spi", and that's a terrible compatible name.

>  and for using it with CPM you have to add 
> "fsl,cpm1-spi" or "fsl,cpm2-spi" to tell the driver that it is CPM 
> (existing code below).

fsl-spi.txt doesn't describe CPM1/2 at all, but rather QE (CPM3) and
non-CPM.

-Scott


