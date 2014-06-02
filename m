Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaFBV3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaFBV3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:29:45 -0400
Date: Tue, 3 Jun 2014 00:30:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PULL 0/2] vhost enhancements for 3.16
Message-ID: <1401744482-17764-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting with actual patches included.

The following changes since commit 96b2e73c5471542cb9c622c4360716684f8797ed:

  Revert "net/mlx4_en: Use affinity hint" (2014-06-02 00:18:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-next

for you to fetch changes up to 2ae76693b8bcabf370b981cd00c36cd41d33fabc:

  vhost: replace rcu with mutex (2014-06-02 23:47:59 +0300)

----------------------------------------------------------------
Michael S. Tsirkin (2):
      vhost-net: extend device allocation to vmalloc
      vhost: replace rcu with mutex

 drivers/vhost/net.c   | 23 ++++++++++++++++++-----
 drivers/vhost/vhost.c | 10 +++++++++-
 2 files changed, 27 insertions(+), 6 deletions(-)

