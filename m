Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaLCQHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:07:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34655 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbaLCQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:09 -0500
X-Sasl-enc: wSAy5+RfF9tVewITTF8w3qAKutI6HSzlqKFy3h/JUHur 1417622828
Date: Wed, 3 Dec 2014 08:05:45 -0800
From: Greg KH <greg@kroah.com>
To: LiYunzhi <lyz@rock-chips.com>
Cc: ulrich.prinz@googlemail.com, dianders <dianders@chromium.org>,
        heiko <heiko@sntech.de>, huangtao <huangtao@rock-chips.com>,
        wulf <wulf@rock-chips.com>, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, kishon@ti.com, linux-kernel@vger.kernel.org,
        zyw@rock-chips.com
Subject: Re: [PATCH] phy: add Rockchip RK3288 USB2 PHY driver.
Message-ID: <20141203160545.GA12383@kroah.com>
References: <1417614410-15885-1-git-send-email-lyz@rock-chips.com>
 <1417614410-15885-2-git-send-email-lyz@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417614410-15885-2-git-send-email-lyz@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 09:46:50PM +0800, LiYunzhi wrote:
> From: lyz <lyz@rock-chips.com>
> 
> Add a driver for the Rockchip SoC internal USB2.0 PHY.
> This driver currently support RK3288.
> 
> Signed-off-by: lyz <lyz@rock-chips.com>

Is this the name you use to sign legal documents?  That is what you need
to put in your Signed-off-by: and "From:" lines.

thanks,

greg k-h
