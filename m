Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaD2B4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:56:13 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:6412
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740AbaD2B4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:56:11 -0400
Date: Tue, 29 Apr 2014 08:45:05 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
Message-ID: <20140429004504.GB21852@shlinux1.ap.freescale.net>
References: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
 <20140424003854.GA25407@shlinux1.ap.freescale.net>
 <1398349891.4724.233.camel@iivanov-dev>
 <72215f7fa6764097801285b965726233@BL2PR03MB226.namprd03.prod.outlook.com>
 <1398693815.5214.15.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398693815.5214.15.camel@iivanov-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(51704005)(24454002)(199002)(189002)(80976001)(77982001)(6806004)(44976005)(76482001)(79102001)(80022001)(46406003)(81342001)(101416001)(46102001)(83506001)(83322001)(31966008)(85852003)(19580405001)(19580395003)(20776003)(47776003)(74502001)(74662001)(4396001)(99396002)(54356999)(87936001)(97756001)(33656001)(50986999)(92566001)(76176999)(81542001)(77096999)(86362001)(92726001)(23726002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB023;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0196A226D1
Authentication-Results: spf=none (sender IP is 192.88.158.246)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:03:35PM +0300, Ivan T. Ivanov wrote:
> On Fri, 2014-04-25 at 03:10 +0000, Peter Chen wrote:
> >  
> > > 
> > > On Thu, 2014-04-24 at 08:38 +0800, Peter Chen wrote:
> > > > On Wed, Apr 23, 2014 at 03:28:01PM +0300, Ivan T. Ivanov wrote:
> > > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > >
> > > > > This series intend to fix driver, which was broken for a while.
> > > > > It is used to create peripheral role device, which in coordination
> > > > > with phy-usb-msm driver could provide USB2.0 gadget support for
> > > > > Qualcomm targets.
> > > > >
> > > > > Changes since version 3.
> > > > >
> > > > >  - Fix typo in devicetree description file.
> > > > >
> > > > > Previews version can be found here:
> > > >
> > > > Since in your phy's patchset, you also access portsc which is in
> > > > chipidea register region, it is not a standard way.
> > > > In case, you will change something at chipidea driver in future when
> > > > you re-work your next revision phy's patchset, I do not send this
> > > > patchset to Greg right now.
> > > >
> > > 
> > > Did you see problems with _this_ particular patch set? There is no direct
> > > dependency between PHY patches and these changes.
> > > 
> >  
> > I have not seen problems for this patch set, if you make sure the current
> > phy operation (eg, "phy_type) at chipidea core does not affect you,
> > I am glad to accept this.
> 
> You mean phy_mode? Peripheral functionality is tested on top of
> current linus/master and it looks fine.
> 

Applied, thanks

-- 

Best Regards,
Peter Chen
