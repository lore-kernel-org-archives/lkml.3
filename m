Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3HUS0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:26:40 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:45429 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3HUS0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:26:39 -0400
Date: Wed, 21 Aug 2013 20:26:46 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input
 configuration
Message-ID: <20130821202646.47af66a5@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Aug 14 12:43:29 PDT 2013, Sebastian Hesselbarth wrote:
> From: Russell King <rmk+kernel at arm.linux.org.uk>
> 
> The video-input-port (VIP) is highly configurable. This prepares
> current driver to allow to configure VIP configuration, as some
> boards connect lcd controller and TDA998x "pin-swapped" and depend
> on VIP to swap the pins by register configuration.
> 
> Signed-off-by: Russell King <rmk+kernel at arm.linux.org.uk>
> Tested-by: Darren Etheridge <detheridge at ti.com>
> Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth at gmail.com>
	[snip]

AFAIK, the TI boards have no "pin-swapped", nor has the Cubox (there is
no need to set the bit CFG_GRA_SWAPRB of the register LCD_SPU_DMA_CTRL0
of the Dove lcd for RGB or YUV formats).

Which board needs a special VIP configuration?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
