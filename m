Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3F1HrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:47:01 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33357 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3F1HrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:47:00 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130628173337.0ab94924c8c626093646caaf@canb.auug.org.au>
References: <20130628173337.0ab94924c8c626093646caaf@canb.auug.org.au>
Date: Fri, 28 Jun 2013 09:46:58 +0200
Message-ID: <CA+icZUWtocVUaehLTF+oaXGyOX3_zASC_qMctZXzu59fFZGrcQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 28
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 9:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130627:
>
> This tree produces the following warning when built for many (all?)
> configs (it has been fixed in the drm tree):
>
> drivers/video/Kconfig:42:error: recursive dependency detected!
> drivers/video/Kconfig:42:       symbol FB is selected by DRM_KMS_HELPER
> drivers/gpu/drm/Kconfig:29:     symbol DRM_KMS_HELPER is selected by DRM_OMAP
> drivers/gpu/drm/omapdrm/Kconfig:2:      symbol DRM_OMAP depends on FB_OMAP2
> drivers/video/omap2/omapfb/Kconfig:1:   symbol FB_OMAP2 depends on FB
>

Just FYI:

Patch pending in drm-next:

commit 2644ee9614be67abe155f1073bb9e1b737bbca53
"drm/omap: drop the !FB_OMAP2 dep"

- Sedat -

[1] http://cgit.freedesktop.org/~airlied/linux/patch/?id=2644ee9614be67abe155f1073bb9e1b737bbca53
