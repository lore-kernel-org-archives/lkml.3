Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3BRQIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:08:13 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33417 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693Ab3BRQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:08:08 -0500
From: Andy King <acking@vmware.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: davem@davemloft.net, pv-drivers@vmware.com, kraxel@redhat.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 0/4] Minor vSockets fixes
Date: Mon, 18 Feb 2013 08:04:09 -0800
Message-Id: <1361203453-1347-1-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor vSockets fixes, two of which were reported on LKML.

Andy King (2):
  VSOCK: Remove hypervisor-only socket option
  VSOCK: Don't reject PF_VSOCK protocol

Dmitry Torokhov (2):
  VSOCK: get rid of EXPORT_SYMTAB
  VSOCK: get rid of vsock_version.h

 include/uapi/linux/vm_sockets.h |    8 --------
 net/vmw_vsock/af_vsock.c        |    7 ++-----
 net/vmw_vsock/vmci_transport.c  |    2 --
 net/vmw_vsock/vsock_version.h   |   22 ----------------------
 4 files changed, 2 insertions(+), 37 deletions(-)
 delete mode 100644 net/vmw_vsock/vsock_version.h

-- 
1.7.4.1

