Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3CRLTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab3CRLTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:19:31 -0400
Date: Mon, 18 Mar 2013 13:20:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asias@redhat.com, mst@redhat.com,
        nab@linux-iscsi.org, target-devel@vger.kernel.org
Subject: [PULL] vhost: tcm_vhost fixes for 3.9
Message-ID: <20130318112003.GA7809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8c6216d7f118a128678270824b6a1286a63863ca:

  Revert "ip_gre: make ipgre_tunnel_xmit() not parse network header as IP unconditionally" (2013-03-16 23:00:41 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

for you to fetch changes up to deb7cb067dabd3be625eaf5495da8bdc97377fc1:

  tcm_vhost: Flush vhost_work in vhost_scsi_flush() (2013-03-17 13:04:14 +0200)

----------------------------------------------------------------
Asias He (2):
      tcm_vhost: Add missed lock in vhost_scsi_clear_endpoint()
      tcm_vhost: Flush vhost_work in vhost_scsi_flush()

 drivers/vhost/tcm_vhost.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)
