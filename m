Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaENQFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:05:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaENQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:05:22 -0400
Date: Wed, 14 May 2014 18:05:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 0/8] Add Allwinner A31 USB support
Message-ID: <20140514160520.GA4679@kroah.com>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140514123419.GK29258@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514123419.GK29258@lukather>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 02:34:19PM +0200, Maxime Ripard wrote:
> On Tue, May 13, 2014 at 05:44:14PM +0200, Maxime Ripard wrote:
> > Hi everyone,
> > 
> > This patchset adds support for the USB controllers found in the
> > Allwinner A31.
> > 
> > While the design is similar to the earlier Allwinner SoCs that are
> > already supported, a few details here and there change, like the fact
> > that the PHYs now have one clock per phy, while it used to be only one
> > for all the PHYs.
> > 
> > Resent adding Alan Stern's Acked-by and puting Greg KH in the
> > recipients this time...
> 
> Applied patches 2, 7 and 8.

Feel free to apply patches 5 and 6 to your tree, as your branch needs
these, with my:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Or, if you want me to take them, just let me know and I will.

thanks,

greg k-h
