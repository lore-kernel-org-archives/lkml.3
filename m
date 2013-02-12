Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab3BLLbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:31:12 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50245 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab3BLLbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:31:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1302102344160.28198@skynet.skynet.ie>
References: <alpine.DEB.2.00.1302102344160.28198@skynet.skynet.ie>
Date: Tue, 12 Feb 2013 21:31:08 +1000
Message-ID: <CAPM=9txsMWT4MiJna34q8Fg0wPWL3GhtspTmVko=pvYL9Fvikg@mail.gmail.com>
Subject: Re: [git pull] drm nouveau fixes.
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> just 3 nouveau fixes, all user visible issues, I have one radeon
> regression fix I'm hoping to send tomorrow once I'm happy with it.

Okay I've added the radeon regression fix on top as well

The following changes since commit ff7c60c580d9722f820d85c9c58ca55ecc1ee7c4:

  drm/ttm: fix fence locking in ttm_buffer_object_transfer, 2nd try
(2013-02-08 10:44:31 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to de0babd60d8d43b58fd06a7803151d32cb589af0:

  drm/radeon: enforce use of radeon_get_ib_value when reading user cmd
(2013-02-12 16:56:25 +1000)

----------------------------------------------------------------
Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes-3.8' of
git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Jerome Glisse (1):
      drm/radeon: enforce use of radeon_get_ib_value when reading user cmd

Maarten Lankhorst (1):
      drm/nouveau: use different register to wait for secret scrubber

Marcin Slusarz (1):
      drm/nouveau: add lockdep annotations

Roy Spliet (1):
      drm/nv50/fb: Fix nullptr-deref on IGPs

 drivers/gpu/drm/nouveau/core/core/falcon.c         |  7 +-
 drivers/gpu/drm/nouveau/core/core/subdev.c         |  2 +-
 drivers/gpu/drm/nouveau/core/include/core/object.h |  7 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  5 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  3 +
 drivers/gpu/drm/radeon/evergreen_cs.c              | 86 +++++++++++-----------
 drivers/gpu/drm/radeon/r600_cs.c                   | 38 +++++-----
 8 files changed, 81 insertions(+), 71 deletions(-)
