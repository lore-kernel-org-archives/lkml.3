Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaDYDK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:10:28 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:28876
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750750AbaDYDKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:10:25 -0400
X-Greylist: delayed 91316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 23:10:25 EDT
From: Peter Chen <Peter.Chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: RE: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
Thread-Topic: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
Thread-Index: AQHPXu+mJHPNzZ7RFUW3WdUPA6ta2psgc2GAgABihICAANGfYA==
Date: Fri, 25 Apr 2014 03:10:21 +0000
Message-ID: <72215f7fa6764097801285b965726233@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
	 <20140424003854.GA25407@shlinux1.ap.freescale.net>
 <1398349891.4724.233.camel@iivanov-dev>
In-Reply-To: <1398349891.4724.233.camel@iivanov-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(199002)(189002)(24454002)(76176999)(50986999)(81542001)(74316001)(4396001)(92566001)(31966008)(81342001)(54356999)(79102001)(33646001)(83322001)(19580395003)(46102001)(86362001)(80976001)(19580405001)(76482001)(87936001)(85852003)(20776003)(80022001)(83072002)(99396002)(74662001)(99286001)(77982001)(76576001)(2656002)(66066001)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB226;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:F6E7FB91.8D2ADF13.BDED3B68.50F29023.20219;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3P3B1Qg003240


 
> 
> On Thu, 2014-04-24 at 08:38 +0800, Peter Chen wrote:
> > On Wed, Apr 23, 2014 at 03:28:01PM +0300, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > >
> > > This series intend to fix driver, which was broken for a while.
> > > It is used to create peripheral role device, which in coordination
> > > with phy-usb-msm driver could provide USB2.0 gadget support for
> > > Qualcomm targets.
> > >
> > > Changes since version 3.
> > >
> > >  - Fix typo in devicetree description file.
> > >
> > > Previews version can be found here:
> >
> > Since in your phy's patchset, you also access portsc which is in
> > chipidea register region, it is not a standard way.
> > In case, you will change something at chipidea driver in future when
> > you re-work your next revision phy's patchset, I do not send this
> > patchset to Greg right now.
> >
> 
> Did you see problems with _this_ particular patch set? There is no direct
> dependency between PHY patches and these changes.
> 
 
I have not seen problems for this patch set, if you make sure the current
phy operation (eg, "phy_type) at chipidea core does not affect you,
I am glad to accept this.

Peter
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
