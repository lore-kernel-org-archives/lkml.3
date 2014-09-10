Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaIJW06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:26:58 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58925 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaIJW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:26:56 -0400
Date: Wed, 10 Sep 2014 15:26:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, afaerber@suse.de,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] ARM: dts: Add Peach Pi dts entry for Atmel
 touchpad
Message-ID: <20140910222652.GG38736@core.coreip.homeip.net>
References: <1410348691-18317-1-git-send-email-javier.martinez@collabora.co.uk>
 <1410348691-18317-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410348691-18317-3-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:31:30PM +0200, Javier Martinez Canillas wrote:
> The Peach Pi board has an Atmel maXTouch trackpad device.
> Add the needed Device Tree nodes to support it.
> 
> This Device Tree change is based on the Chrome OS 3.8 tree
> but adapted to use the mainline Atmel maXTouch DT binding.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

This one looks fine to me as well.

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
