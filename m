Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbaFKPXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:23:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaFKPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:23:24 -0400
Date: Wed, 11 Jun 2014 08:27:14 -0700
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'David Airlie'" <airlied@linux.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>
Subject: Re: [PATCH] devres: remove devm_request_and_ioremap()
Message-ID: <20140611152714.GB27630@kroah.com>
References: <000901cf8532$026e5d40$074b17c0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901cf8532$026e5d40$074b17c0$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:00:05PM +0900, Jingoo Han wrote:
> devm_request_and_ioremap() was obsoleted by the commit 7509657
> ("lib: devres: Introduce devm_ioremap_resource()") and has been
> deprecated for a long time. So, let's remove this function.
> In addition, all usages of devm_request_and_ioremap() are also
> removed.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Based-on the latest linux kernel
> (dfb9454 Merge git://www.linux-watchdog.org/linux-watchdog)
> 
>  Documentation/driver-model/devres.txt              |    1 -
>  drivers/bus/brcmstb_gisb.c                         |    6 +-
>  drivers/gpu/drm/armada/armada_crtc.c               |    8 +-
>  include/linux/device.h                             |    2 -
>  lib/devres.c                                       |   28 ------
>  scripts/coccinelle/api/devm_ioremap_resource.cocci |   90 --------------------
>  6 files changed, 6 insertions(+), 129 deletions(-)
>  delete mode 100644 scripts/coccinelle/api/devm_ioremap_resource.cocci

Thanks, I'll queue it up after 3.16-rc1 is out.

greg k-h
