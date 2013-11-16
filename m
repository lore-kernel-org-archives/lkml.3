Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3KPOZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:25:16 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56648 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3KPOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:25:10 -0500
MIME-Version: 1.0
Date: Sat, 16 Nov 2013 09:25:09 -0500
X-Google-Sender-Auth: 47SlxJr3_8M-KWb23eJOepvXiok
Message-ID: <CA+5PVA7hq9e2twtQ2e24VvF+KHJ_XS4uVskWRQo+g7z3VpmKXw@mail.gmail.com>
Subject: DRM_TEGRA not buildable as a module
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Thierry Reding <treding@nvidia.com>,
        =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Dave Airlie <airlied@redhat.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-tegra@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The commit below seems to have made the Tegra DRM driver a bool option
instead of tristate:

commit dee8268f8fb218c9e9b604a40f7dbdd395e910f9
Author: Thierry Reding <treding@nvidia.com>
Date:   Wed Oct 9 10:32:49 2013 +0200

    drm/tegra: Move driver to DRM tree

    In order to make subsystem-wide changes easier, move the Tegra DRM
    driver back into the DRM tree.

    Signed-off-by: Thierry Reding <treding@nvidia.com>

That means you can't build the driver as a module.  Was this intended?
 The changelog doesn't mention anything about that and the existing
help text on the option seems to imply it should be buildable as a
module.

josh
