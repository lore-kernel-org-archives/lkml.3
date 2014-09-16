Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaIPNxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:53:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46366 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753809AbaIPNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:53:51 -0400
Date: Tue, 16 Sep 2014 15:53:47 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/9] usb: rename phy to usb_phy in HCD
Message-ID: <20140916135347.GC4869@kwain>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410777309-12552-5-git-send-email-antoine.tenart@free-electrons.com>
 <54172B42.1060606@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54172B42.1060606@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:09:06PM +0300, Sergei Shtylyov wrote:
> On 9/15/2014 1:35 PM, Antoine Tenart wrote:
> 
> >The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> >modifications are done in all drivers accessing it.
> 
> >Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> >Acked-by: Alan Stern <stern@rowland.harvard.edu>
> >---
> >  drivers/usb/chipidea/host.c   |  2 +-
> >  drivers/usb/core/hcd.c        | 20 ++++++++++----------
> >  drivers/usb/core/hub.c        |  8 ++++----
> >  drivers/usb/host/ehci-fsl.c   | 16 ++++++++--------
> >  drivers/usb/host/ehci-hub.c   |  2 +-
> >  drivers/usb/host/ehci-msm.c   |  4 ++--
> >  drivers/usb/host/ehci-tegra.c | 16 ++++++++--------
> >  drivers/usb/host/ohci-omap.c  | 20 ++++++++++----------
> >  drivers/usb/misc/lvstest.c    |  8 ++++----
> 
>    I have already re-posted this patch (adding it to my generic PHY
> patch to form a short series) with this file added, and CC'ed you. I
> haven't heard any protest (perhaps I missed it?), why reiterate with
> this patch instead of basing the patchset on my most recent posting?

Well, I can only return the question.

Anyway, this is not really important. I'll let the maintainers decide
which series they want this patch in, and I'll make the needed
modifications if needed.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
