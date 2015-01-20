Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbbATQZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbbATQZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:25:11 -0500
Date: Tue, 20 Jan 2015 18:25:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 00/05] virtio_pci modern driver fixups
Message-ID: <1421771093-1589-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are fixup patches for virtio pci modern.
I think it's best to simply squash them in the
appropriate original patches - rebase -i and then apply,
then rebase -i --autosquash to do this automatically.

You can also find how your branch looks with patches applied
but before the rebase -i --autosquash in my tree:
	git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git virtio-next
or after rebase -i --autosquash:
	git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-next

Last patch is a cleanup, does not have to be squashed.

Or if it's all too much bother, I can repost the whole series after fixups.

Michael S. Tsirkin (15):
  fixup! virtio_pci: modern driver
  fixup! virtio_pci: modern driver
  fixup! virtio_pci: macros for PCI layout offsets
  fixup! virtio_pci: add module param to force legacy mode
  virtio_pci_modern: drop an unused function

-- 
MST

