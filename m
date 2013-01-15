Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3AOSMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:12:03 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61511 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab3AOSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:12:00 -0500
Date: Tue, 15 Jan 2013 10:12:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: remove unused APIs from Tegra PHY.
Message-ID: <20130115181256.GA5172@kroah.com>
References: <1358245170-22083-1-git-send-email-vbyravarasu@nvidia.com>
 <50F59A43.7050308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F59A43.7050308@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:04:51AM -0700, Stephen Warren wrote:
> On 01/15/2013 03:19 AM, Venu Byravarasu wrote:
> > As tegra_usb_phy_clk_disable/enable() are not being
> > used, removing them.
> 
> Greg, Felipe,
> 
> Again if I may, I'll take this through the Tegra tree. I think the next
> set of patches that Venu posts should actually expose the dependencies
> between his USB patches and the Tegra clock framework rework, which are
> why I want to do this.

I'll let Felipe judge these, as they are in his area, it's up to him.

greg k-h
