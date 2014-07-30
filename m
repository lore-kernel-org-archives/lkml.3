Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaG3TwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:52:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55265 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaG3TwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:52:15 -0400
Date: Wed, 30 Jul 2014 12:52:42 -0700
From: Olof Johansson <olof@lixom.net>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, kishon@ti.com, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Enable TI PIPE3 PHY driver
Message-ID: <20140730195242.GF18384@quad.lixom.net>
References: <1406540737-9493-1-git-send-email-rogerq@ti.com>
 <1406625328-26112-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406625328-26112-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 12:15:28PM +0300, Roger Quadros wrote:
> This driver is needed by SATA, PCIe and USB modules on TI SoCs.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

What's this based on? It doesn't apply on top of next/defconfig. Please
base it on there and resend. (or linux-next or our for-next branch, which
should be all the same).

Thanks,

-Olof
