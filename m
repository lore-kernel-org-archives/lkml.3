Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaGIPI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:08:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48465 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932651AbaGIPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:08:52 -0400
Date: Wed, 9 Jul 2014 17:08:48 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] usb: add support to the PHY framework for HCD
Message-ID: <20140709150848.GC4510@kwain>
References: <1404901036-27682-4-git-send-email-antoine.tenart@free-electrons.com>
 <Pine.LNX.4.44L0.1407091035570.873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1407091035570.873-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Jul 09, 2014 at 10:41:50AM -0400, Alan Stern wrote:
> On Wed, 9 Jul 2014, Antoine Ténart wrote:
> 
> > This patch adds the support to PHY framework in HCD code while keeping
> > the USB PHY compatibility. Changes are done in both the HCD common code
> > and in the drivers accessing its PHY. This is done in two steps:
> > renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
> > usb_hcd structure.
> 
> Can you split the two steps into two separate patches?  It will make 
> them easier to review.

Sure, I was not sure how to choose the patch granularity for this
series. I'll wait a bit for people to test if this doesn't break the
existing and I'll separate this into two patches.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
