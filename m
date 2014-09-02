Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIBJJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:09:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36369 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbaIBJJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:09:13 -0400
Date: Tue, 2 Sep 2014 11:08:32 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, kishon@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Message-ID: <20140902090832.GB12536@kwain>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
 <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140826102239.GD16758@peterchendt>
 <20140829142535.GA16609@kwain>
 <20140901011341.GD3854@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140901011341.GD3854@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 01, 2014 at 09:13:43AM +0800, Peter Chen wrote:
> On Fri, Aug 29, 2014 at 04:25:35PM +0200, Antoine Tenart wrote:
> > On Tue, Aug 26, 2014 at 06:22:40PM +0800, Peter Chen wrote:
> > > On Fri, Aug 22, 2014 at 05:50:19PM +0200, Antoine Ténart wrote:
> > > 
> > > If the common usb_otg and usb_phy struct still has another's pointer, you
> > > may not need to add this patch.
> > 
> > Except if we want to access the OTG member when not using an USB PHY.
> 
> If there is no USB PHY, the probe at core.c will turn error.

I meant if we use a PHY from the common PHY framework (struct phy) and
not one from the USB one (struct usb_phy). The 'struct phy' does not
have a pointer to an OTG structure.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
