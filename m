Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaGHBlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:41:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaGHBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:41:04 -0400
Date: Mon, 7 Jul 2014 18:45:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] phy: core: Support regulator supply for PHY power
Message-ID: <20140708014527.GD13844@kroah.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
 <1404715705-5041-7-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404715705-5041-7-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 12:18:23PM +0530, Kishon Vijay Abraham I wrote:
> From: Roger Quadros <rogerq@ti.com>
> 
> Some PHYs can be powered by an external power regulator.
> e.g. USB_HS PHY on DRA7 SoC. Make the PHY core support a
> power regulator.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-core.c  |   26 ++++++++++++++++++++++++++
>  include/linux/phy/phy.h |    2 ++
>  2 files changed, 28 insertions(+)

This looks like a new feature :(

again, I can't take that for 3.16-final, you know better...

greg k-h
