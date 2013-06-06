Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3FFM2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809Ab3FFM2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:28:48 -0400
Date: Thu, 6 Jun 2013 15:20:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Asias He <asias@redhat.com>, David Miller <davem@davemloft.net>,
        Tommi Rantala <tt.rantala@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] vhost fixes for 3.10
Message-ID: <1370521145-9723-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches fixing the fallout from the vhost cleanup in 3.10.
Thanks to Tommi Rantala who reported the issue.

Tommi, could you please confirm this fixes the crashes for you?

Michael S. Tsirkin (2):
  vhost: check owner before we overwrite ubuf_info
  vhost: fix ubuf_info cleanup

 drivers/vhost/net.c   | 26 +++++++++++---------------
 drivers/vhost/vhost.c |  8 +++++++-
 drivers/vhost/vhost.h |  1 +
 3 files changed, 19 insertions(+), 16 deletions(-)

-- 
MST

