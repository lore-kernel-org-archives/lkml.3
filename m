Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaD1OEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:04:32 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:32891 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaD1OEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:04:30 -0400
Message-ID: <1398693815.5214.15.camel@iivanov-dev>
Subject: Re: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Mon, 28 Apr 2014 17:03:35 +0300
In-Reply-To: <72215f7fa6764097801285b965726233@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
	 <20140424003854.GA25407@shlinux1.ap.freescale.net>
	 <1398349891.4724.233.camel@iivanov-dev>
	 <72215f7fa6764097801285b965726233@BL2PR03MB226.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 03:10 +0000, Peter Chen wrote:
>  
> > 
> > On Thu, 2014-04-24 at 08:38 +0800, Peter Chen wrote:
> > > On Wed, Apr 23, 2014 at 03:28:01PM +0300, Ivan T. Ivanov wrote:
> > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > >
> > > > This series intend to fix driver, which was broken for a while.
> > > > It is used to create peripheral role device, which in coordination
> > > > with phy-usb-msm driver could provide USB2.0 gadget support for
> > > > Qualcomm targets.
> > > >
> > > > Changes since version 3.
> > > >
> > > >  - Fix typo in devicetree description file.
> > > >
> > > > Previews version can be found here:
> > >
> > > Since in your phy's patchset, you also access portsc which is in
> > > chipidea register region, it is not a standard way.
> > > In case, you will change something at chipidea driver in future when
> > > you re-work your next revision phy's patchset, I do not send this
> > > patchset to Greg right now.
> > >
> > 
> > Did you see problems with _this_ particular patch set? There is no direct
> > dependency between PHY patches and these changes.
> > 
>  
> I have not seen problems for this patch set, if you make sure the current
> phy operation (eg, "phy_type) at chipidea core does not affect you,
> I am glad to accept this.

You mean phy_mode? Peripheral functionality is tested on top of
current linus/master and it looks fine.

Regards,
Ivan

> 
> Peter
> NrybXǧv^)޺{.n+{zXܨ}Ơz&j:+vzZ++zfh~izw?&)ߢf^jǫym@Aa0hi


