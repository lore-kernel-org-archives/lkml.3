Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbaLOVOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:14:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaLOVOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:14:07 -0500
Date: Mon, 15 Dec 2014 23:13:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/3] fix up vringh/mic sparse errors
Message-ID: <1418678019-31629-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes remaining sparse warnings in vringh and mic by using
virtio 1.0 compliant wrappers.

This also needs by get_user patches to avoid getting warnings
from these calls.

Tested by running vringh_test.

Rusty, I prefer fixing all these warnings for 3.19, any objections?

Michael S. Tsirkin (3):
  vringh: 64 bit features
  vringh: initial virtio 1.0 support
  mic/host: initial virtio 1.0 support

 include/linux/vringh.h              |  37 ++++++++++-
 drivers/misc/mic/host/mic_debugfs.c |  18 ++++--
 drivers/vhost/vringh.c              | 125 ++++++++++++++++++++++--------------
 3 files changed, 123 insertions(+), 57 deletions(-)

-- 
MST

