Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaJAMjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:39:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34291 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053AbaJAMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:39:19 -0400
Date: Wed, 1 Oct 2014 14:39:14 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de, arnd@arndb.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20141001123914.GA25307@kwain>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140929150837.GD8912@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140929150837.GD8912@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Arnd, Felipe,

On Mon, Sep 29, 2014 at 05:08:37PM +0200, Antoine Tenart wrote:
> On Tue, Sep 23, 2014 at 12:28:03PM +0200, Antoine Tenart wrote:
> > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> > and DMA mask, to support USB2 ChipIdea controllers that don't need
> > specific functions.
> 
> Did we agree on the modifications needed to get this accepted? If so,
> can one of you sum up what's need to be done, I got a bit lost reading
> all the discussions on this thread.
> 
> Anyway, that would be good to get this series accepted as the Berlin USB
> support depends on it. This series has been out since the beginning of
> June and non-critical changes can be added by future series.

I'm seriously considering sending a new version with dt-only support as I
don't need the other case. There are still many discussions between the
three of you regarding DMA support, which is not a problem for my use
case. As this is not a modification of an existing driver, future
additions can be done to support more cases later and we do not need
this driver to handle all possible cases right now as this won't be a
regression.

Please, can one of you sum up the modifications needed to get this
accepted, if any. If the dt part is fine for you, I'll resend this
series with dt-only support. The platform compatibility can surely be
added later, when needed by someone, and when an agreement on how to do
it is reached.

I'm afraid this series is currently blocked by implementation related
discussions not linked with the USB Berlin support, while this could be
done as a follow up series.

Thanks,

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
