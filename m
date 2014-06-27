Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaF0QGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:06:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752688AbaF0QGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:06:01 -0400
Date: Fri, 27 Jun 2014 18:05:57 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 05/12] usb: phy: add the Berlin USB PHY driver
Message-ID: <20140627160557.GA6622@kwain>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-6-git-send-email-antoine.tenart@free-electrons.com>
 <20140627155622.GL8069@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627155622.GL8069@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Jun 27, 2014 at 10:56:22AM -0500, Felipe Balbi wrote:
> On Tue, Jun 24, 2014 at 12:35:14PM +0200, Antoine Ténart wrote:
> > Add the driver driving the Marvell Berlin USB PHY. This allows to
> > initialize the PHY and to use it from the USB driver later.
> > 
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> 
> since this is a brand new driver, it should go to drivers/phy instead.

This PHY is used by a ChipIdea USB driver, which uses the provided
common function for ChipIdea. These functions use the usb_phy framework.
That's why this PHY driver is there.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
