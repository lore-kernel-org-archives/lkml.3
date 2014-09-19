Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbaISXw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:52:27 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35262 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbaISXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <1411131533-15494-1-git-send-email-a.hajda@samsung.com>
References: <1411131533-15494-1-git-send-email-a.hajda@samsung.com>
Date: Fri, 19 Sep 2014 17:52:24 -0600
Message-ID: <CAD8Lp47N7L2jeMpjTGDBbkzXN=SPMnX3OcdyV3XqNR6iG2yGbg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/exynos: switch to universal plane API
From: Daniel Drake <drake@endlessm.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 6:58 AM, Andrzej Hajda <a.hajda@samsung.com> wrote:
> The patch replaces legacy functions
> drm_plane_init() / drm_crtc_init() with
> drm_universal_plane_init() and drm_crtc_init_with_planes().
> It allows to replace fake primary plane with the real one.
> Additionally the patch leaves cleanup of crtcs to core,
> this way planes and crtcs are cleaned in correct order.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Thanks Andrzej! With your patch the crashes I was seeing are gone.

Daniel
