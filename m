Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3HZIPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:15:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54692 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab3HZIPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:15:51 -0400
Message-ID: <521B0E79.6060506@ti.com>
Date: Mon, 26 Aug 2013 13:44:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>,
        <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH v11 0/8] PHY framework
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
In-Reply-To: <1377063973-22044-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday 21 August 2013 11:16 AM, Kishon Vijay Abraham I wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle.
> 
> This framework will be of use only to devices that uses external PHY (PHY
> functionality is not embedded within the controller).
> 
> The intention of creating this framework is to bring the phy drivers spread
> all over the Linux kernel to drivers/phy to increase code re-use and to
> increase code maintainability.
> 
> Comments to make PHY as bus wasn't done because PHY devices can be part of
> other bus and making a same device attached to multiple bus leads to bad
> design.
> 
> If the PHY driver has to send notification on connect/disconnect, the PHY
> driver should make use of the extcon framework. Using this susbsystem
> to use extcon framwork will have to be analysed.
> 
> You can find this patch series @
> git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing

Looks like there are not further comments on this series. Can you take this in
your misc tree?

Thanks
Kishon
