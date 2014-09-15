Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaIOKAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:00:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36664 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367AbaIOKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:00:40 -0400
Date: Mon, 15 Sep 2014 12:00:36 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "yoshihiro.shimoda.uh@renesas.com" <yoshihiro.shimoda.uh@renesas.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/9] usb: rename transceiver and phy to usb_phy in
 ChipIdea
Message-ID: <20140915100036.GA8254@kwain>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140911002858.GC3609@peterchendt>
 <20140912135319.GE18774@kwain>
 <32020f4ba5294d75811263cbb716948b@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32020f4ba5294d75811263cbb716948b@BN1PR0301MB0772.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 06:27:06AM +0000, Peter Chen wrote:
>  
> > On Thu, Sep 11, 2014 at 08:28:59AM +0800, Peter Chen wrote:
> > > On Wed, Sep 03, 2014 at 09:40:38AM +0200, Antoine Tenart wrote:
> > >
> > > Again, rebase my next-tree, and modify the msm part.
> > 
> > git://github.com/hzpeterchen/linux-usb.git ci-for-usb-next ?
> > 
> 
> Yes.
> 
> > I can do that. But that would be easier if you rebased this branch on top of at
> > least v3.17-rc1 so that other series depending on this one could be tested easily
> > (like my other series introducing the USB support for Marvell Berlin).
> > 
> > Antoine
>  
> Done 

Thanks! I'll send a new version today then.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
