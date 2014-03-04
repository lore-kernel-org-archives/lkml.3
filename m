Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaCDJaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:30:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58253 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaCDJag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:30:36 -0500
Message-ID: <53159D0D.2040009@ti.com>
Date: Tue, 4 Mar 2014 14:59:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 03/12] phy: ti-pipe3: cleanup clock handling
References: <1393859254-10937-1-git-send-email-rogerq@ti.com> <1393859254-10937-4-git-send-email-rogerq@ti.com>
In-Reply-To: <1393859254-10937-4-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 03 March 2014 08:37 PM, Roger Quadros wrote:
> As this driver is no longer USB specific, use generic clock names.
> - Fix PLL_SD_SHIFT from 9 to 10
> - As optclk and wkupclk may not be always required, don't bail out
> if they aren't available.

I think here too we face the same problem as for PHY. What if a 
particular platform needs a clock but is not available. I don't want 
this to be blocking though.

Thanks
Kishon
