Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaFFHLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:11:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40155 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803AbaFFHLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:11:16 -0400
Date: Fri, 6 Jun 2014 09:11:06 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        kishon <kishon@ti.com>, sebastian.hesselbarth@gmail.com,
        Felipe Balbi <balbi@ti.com>, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] usb: phy: add the Berlin USB PHY driver
Message-ID: <20140606071106.GA30156@kwain>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401983326-19205-5-git-send-email-antoine.tenart@free-electrons.com>
 <CAFp+6iEKLD_rLg84h3J2oyzw7vizEV-Eqo0e_jqurx_v9ZX2JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFp+6iEKLD_rLg84h3J2oyzw7vizEV-Eqo0e_jqurx_v9ZX2JA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 06, 2014 at 12:09:06PM +0530, Vivek Gautam wrote:
> On Thu, Jun 5, 2014 at 9:18 PM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
> > Add the driver driving the Marvell Berlin USB PHY. This allows to
> > initialize the PHY and to use it from the USB driver later.
> 
> Just out of curiosity, going forward we would like to have phy drivers based on
> generic phy framework (drivers/phy).
> Any particular reason that we are still adding phy drivers in usb-phy layer ?
> 
> Looking at it, seems like it can very well be written based on phy framework.

This USB controller are ChipIdea compatible, and the ChipIdea common
functions use the usb_phy framework. That's why this PHY driver is
there.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
