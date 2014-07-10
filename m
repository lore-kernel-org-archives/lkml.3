Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaGJNsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:48:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56170 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbaGJNsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:48:03 -0400
Date: Thu, 10 Jul 2014 15:47:58 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: move the OTG state from the USB PHY to the OTG
 structure
Message-ID: <20140710134758.GA32462@kwain>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140710134023.GJ15340@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140710134023.GJ15340@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Jul 10, 2014 at 08:40:23AM -0500, Felipe Balbi wrote:
> On Wed, Jul 09, 2014 at 12:17:13PM +0200, Antoine Ténart wrote:
> > Before using the PHY framework instead of the USB PHY one, we need to
> > move the OTG state into another place, since it won't be available when
> > USB PHY isn't used. This patch moves the OTG state into the OTG
> > structure, and makes all the needed modifications in the drivers
> > using the OTG state.
> > 
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> 
> This looks good to me. I'm interested in what will be the best way to
> merge this series :-)

I was asking myself the same question :) If splits or squashes are needed
please ask. At least, I'll split the s/phy/usb_phy/ and the generic PHY
addition in two patches as Alan asked.

Antoine


-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
