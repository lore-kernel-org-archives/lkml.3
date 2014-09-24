Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaIXIFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:05:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaIXIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:05:35 -0400
Date: Tue, 23 Sep 2014 22:11:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-usb@vger.kernel.org, Peter.Chen@freescale.com,
        stern@rowland.harvard.edu, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, balbi@ti.com, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        yoshihiro.shimoda.uh@renesas.com, linux-kernel@vger.kernel.org,
        antoine.tenart@free-electrons.com
Subject: Re: [PATCH v5 1/2] usb: rename phy to usb_phy in HCD
Message-ID: <20140924051138.GA4440@kroah.com>
References: <5072811.p8odmvpxdS@wasted.cogentembedded.com>
 <2282553.NrZjRxyKlv@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2282553.NrZjRxyKlv@wasted.cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 01:42:09AM +0400, Sergei Shtylyov wrote:
> From: Antoine Tenart <antoine.tenart@free-electrons.com>
> 
> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> modifications are done in all drivers accessing it.
> This is in preparation to adding the generic PHY support.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> [Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved rejects
> caused by patch reordering, updated changelog.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> ---
> Changes in version 5:
> - imported the patch from Antoine Tenart's series;
> - added missing 'drivers/usb/misc/lvstest.c' file;
> - resolved rejects caused by patch reordering;
> - refreshed patch;
> - updated changelog.
> 
>  drivers/usb/chipidea/host.c   |    2 +-
>  drivers/usb/core/hcd.c        |   20 ++++++++++----------
>  drivers/usb/core/hub.c        |    8 ++++----
>  drivers/usb/host/ehci-fsl.c   |   16 ++++++++--------
>  drivers/usb/host/ehci-hub.c   |    2 +-
>  drivers/usb/host/ehci-msm.c   |    4 ++--
>  drivers/usb/host/ehci-tegra.c |   16 ++++++++--------
>  drivers/usb/host/ohci-omap.c  |   20 ++++++++++----------
>  drivers/usb/misc/lvstest.c    |    8 ++++----
>  include/linux/usb/hcd.h       |    2 +-
>  10 files changed, 49 insertions(+), 49 deletions(-)

This doesn't apply to my tree at all anymore, can you refresh it and
resend?

thanks,

greg k-h
