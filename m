Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaGFOjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 10:39:41 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39567 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaGFOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 10:39:40 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] virtio-scsi queue for 3.17
Date: Sun,  6 Jul 2014 16:39:25 +0200
Message-Id: <1404657567-17133-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph asked me to rebase the two virtio-scsi patches from
http://thread.gmane.org/gmane.linux.kernel/1717796 that do not apply
anymore, patch 2 and 6.

These are on top of his drivers-for-3.16 branch, more precisely commit
8faeb529b2da (virtio-scsi: fix various bad behavior on aborted requests).

Paolo

Ming Lei (1):
  virtio-scsi: replace target spinlock with seqcount

Venkatesh Srinivas (1):
  virtio-scsi: Implement change_queue_depth for virtscsi targets

 drivers/scsi/virtio_scsi.c | 75 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 13 deletions(-)

-- 
1.8.3.1

