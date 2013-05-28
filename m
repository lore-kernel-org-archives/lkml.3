Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab3E1FSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 01:18:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39396 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab3E1FSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 01:18:51 -0400
Message-ID: <51A43E0A.8090201@ti.com>
Date: Tue, 28 May 2013 10:48:02 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <tomi.valkeinen@ti.com>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1368796954-3499-1-git-send-email-kishon@ti.com>
In-Reply-To: <1368796954-3499-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Friday 17 May 2013 06:52 PM, Kishon Vijay Abraham I wrote:
> In order for controllers to get PHY in case of non dt boot, the phy
> binding information (phy label) should be added in the platform
> data of the controller.

This series would be needed to get MUSB working in OMAP3 boards for 
non-dt boot case. Do you think this is good enough to go in this rc cycle?

Thanks
Kishon
