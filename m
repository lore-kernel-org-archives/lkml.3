Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaGGIzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:55:20 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:10199
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939AbaGGIzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:55:18 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH 0/3] iommu/fsl: Fixes for the PAMU driver.
Thread-Topic: [PATCH 0/3] iommu/fsl: Fixes for the PAMU driver.
Thread-Index: AQHPmb35yYV0TwCm8UCGruqU1woOyZuUTs/w
Date: Mon, 7 Jul 2014 08:55:15 +0000
Message-ID: <e311aca174f04752a2ea27954ee1be0d@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <20140707083216.GA1958@8bytes.org>
In-Reply-To: <20140707083216.GA1958@8bytes.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(13464003)(24454002)(377454003)(51704005)(76576001)(74662001)(50986999)(2656002)(107046002)(105586002)(74502001)(77982001)(76482001)(87936001)(79102001)(19580405001)(54356999)(101416001)(64706001)(106116001)(31966008)(33646001)(106356001)(81542001)(76176999)(92566001)(95666004)(21056001)(85852003)(83322001)(81342001)(66066001)(83072002)(20776003)(86362001)(46102001)(85306003)(80022001)(4396001)(99396002)(74316001)(19580395003)(99286002)(110136001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB466;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joerg.

> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Monday, July 07, 2014 2:02 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> linuxppc-dev@lists.ozlabs.org; alex.williamson@redhat.com
> Subject: Re: [PATCH 0/3] iommu/fsl: Fixes for the PAMU driver.
> 
> On Tue, Jun 24, 2014 at 07:27:14PM +0530, Varun Sethi wrote:
> > This patch set contains fixes for the PAMU driver.
> > The patches are based on 3.16-rc1.
> >
> > Varun Sethi (3):
> >   Fix PAMU window size check.
> >   Fix the device domain attach condition.
> >   Fix the error condition during iommu group creation.
> >
> >  drivers/iommu/fsl_pamu.c        |    8 ++++----
> >  drivers/iommu/fsl_pamu_domain.c |   19 +++++++++----------
> >  2 files changed, 13 insertions(+), 14 deletions(-)
> 
> Applied to iommu/fixes, thanks.
> 

