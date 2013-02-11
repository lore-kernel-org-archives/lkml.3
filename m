Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3BKBKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 20:10:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60501 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3BKBKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 20:10:37 -0500
Date: Sun, 10 Feb 2013 20:10:35 -0500 (EST)
Message-Id: <20130210.201035.2234938856222663233.davem@davemloft.net>
To: acking@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        pv-drivers@vmware.com, kraxel@redhat.com
Subject: Re: [PATCH 0/1] VM Sockets for Linux upstreaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360196636-9357-1-git-send-email-acking@vmware.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>
Date: Wed,  6 Feb 2013 16:23:55 -0800

> In an effort to improve the out-of-the-box experience with Linux kernels for
> VMware users, VMware is working on readying the VM Sockets (VSOCK, formerly
> VMCI Sockets) (vsock) kernel module for inclusion in the Linux kernel. The
> purpose of this post is to acquire feedback on the vsock kernel module.
> 
> Unlike previous submissions, where the new socket family was entirely reliant
> on VMware's VMCI PCI device (and thus VMware's hypervisor), VM Sockets is now
> completely[1] separated out into two parts, each in its own module:
> 
> o Core socket code, which is transport-neutral and invokes transport
>   callbacks to communicate with the hypervisor.  This is vsock.ko.
> o A VMCI transport, which communicates over VMCI with the VMware hypervisor.
>   This is vmw_vsock_vmci_transport.ko, and it registers with the core module
>   as a transport.
> 
> This should provide a path to introducing additional transports, for example
> virtio, with the ultimate goal being to make this new socket family
> hypervisor-neutral.

Applied, thanks.
