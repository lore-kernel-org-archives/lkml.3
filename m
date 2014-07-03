Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbaGCRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:43:32 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:15072
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751285AbaGCRnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:43:31 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
Thread-Topic: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
Thread-Index: AQHPhotyfmKXNHtW5kuAoU6+PbKknZtz3sKAgAACSICAGsQBAIAAGMCg
Date: Thu, 3 Jul 2014 17:43:26 +0000
Message-ID: <092459cf6aa04425bae1bd19b746f0fc@BL2PR03MB468.namprd03.prod.outlook.com>
References: <20140612215954.2754.30263.stgit@bling.home>
	 <20140616151619.GA31771@8bytes.org> <1402932269.3707.35.camel@ul30vt.home>
 <1404403726.1862.78.camel@ul30vt.home>
In-Reply-To: <1404403726.1862.78.camel@ul30vt.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0261CCEEDF
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(377424004)(377454003)(164054003)(189002)(199002)(51704005)(13464003)(19580395003)(2656002)(87936001)(76482001)(81542001)(81342001)(105586002)(107046002)(19580405001)(106356001)(21056001)(106116001)(83322001)(76576001)(74316001)(101416001)(20776003)(86362001)(54356999)(93886003)(79102001)(99396002)(77982001)(85852003)(85306003)(46102001)(31966008)(64706001)(76176999)(99286002)(74662001)(83072002)(50986999)(95666004)(33646001)(80022001)(92566001)(74502001)(66066001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s63Hha8D011120

Hi Alex,
This is on my todo list. I have a requirement for adding sysfs support for PAMU.

Regards
Varun
> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, July 03, 2014 9:39 PM
> To: Joerg Roedel
> Cc: iommu@lists.linux-foundation.org; dwmw2@infradead.org; linux-
> kernel@vger.kernel.org; Sethi Varun-B16395
> Subject: Re: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
> 
> On Mon, 2014-06-16 at 09:24 -0600, Alex Williamson wrote:
> > On Mon, 2014-06-16 at 17:16 +0200, Joerg Roedel wrote:
> > > On Thu, Jun 12, 2014 at 04:12:18PM -0600, Alex Williamson wrote:
> > > > Alex Williamson (3):
> > > >       iommu: Add sysfs support for IOMMUs
> > > >       iommu/intel: Make use of IOMMU sysfs support
> > > >       iommu/amd: Add sysfs support
> > >
> > > I like the general approach. But why do you only enable the x86
> iommus?
> > > Some ARM IOMMUs and PAMU would certainly also benefit from a sysfs
> > > representation of which device is translated by which IOMMU.
> >
> > Only because I have no ability to test the others platforms.  I'd be
> > thrilled if someone working on those IOMMUs could validate this on
> > non-x86.  Thanks,
> 
> Should I re-send this series or are you hoping I'll attempt to piece
> together a non-x86 user for which I have no hardware and can't test?
> Varun, do you have any interest in this for the fsl iommu to try a proof
> of concept?  Thanks,
> 
> Alex

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
