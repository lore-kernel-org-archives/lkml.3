Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab3F1Egq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 00:36:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52640 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3F1Egp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 00:36:45 -0400
Date: Fri, 28 Jun 2013 05:36:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm qxl fix
Message-ID: <alpine.DEB.2.00.1306280535560.14351@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

bad me forgot an access check, possible security issue, but since this is 
the first kernel with it, should be fine to just put it in now.

Dave.

The following changes since commit 426729dcc713b3d1ae802e314030e5556a62da53:

  drm/i915: make compact dma scatter lists creation work with SWIOTLB backend. (2013-06-25 10:39:57 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 18097b91aaff215e843f04b84ec2c686270bb55f:

  drm/qxl: add missing access check for execbuffer ioctl (2013-06-28 13:27:40 +1000)

----------------------------------------------------------------
Dave Airlie (1):
      drm/qxl: add missing access check for execbuffer ioctl

 drivers/gpu/drm/qxl/qxl_ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)
