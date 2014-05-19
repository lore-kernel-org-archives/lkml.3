Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaESI4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:56:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58146 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaESI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <1399995050-28435-6-git-send-email-thierry.reding@gmail.com>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com> <1399995050-28435-6-git-send-email-thierry.reding@gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 19 May 2014 10:56:08 +0200
Message-ID: <CAH9NwWfF_rMWqPRzr7sPFkwwME1ZXG8=Np3NHDEib1MDm1tgWA@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] drm/tegra: Convert to master/component framework
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-13 17:30 GMT+02:00 Thierry Reding <thierry.reding@gmail.com>:
> From: Thierry Reding <treding@nvidia.com>
>
> Instead of the current implementation, reuse the recently introduced
> master/component framework, which is equivalent in most regards. One
> issue is that there is no device to bind the DRM driver to. In order
> to still allow the driver to be probed, expose an interface from the
> host1x device and provide an interface driver to bind to that.
>
> The interface driver then registers (or removes) the master that will be
> used to instantiate and bind the DRM driver. Since the drm_host1x bus
> implementation is now gone the dummy device instantiated by it can no
> longer be used as the parent for the DRM device. However since the
> parent device doesn't need to be modified, the host1x parent device that
> exposes the interface can be used instead.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Is there a git tree somewhere to have a look at? I am interested in the usage
of the master/component framework.

thanks
--
Christian Gmeiner, MSc

https://soundcloud.com/christian-gmeiner
