Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaGUBYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:24:18 -0400
Received: from ozlabs.org ([103.22.144.67]:45360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaGUBYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:24:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: benoit.taine@lip6.fr, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/25] virtio: Replace DEFINE_PCI_DEVICE_TABLE macro use
In-Reply-To: <1405697232-11785-24-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr> <1405697232-11785-24-git-send-email-benoit.taine@lip6.fr>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 21 Jul 2014 10:52:48 +0930
Message-ID: <87oawjzes7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit Taine <benoit.taine@lip6.fr> writes:
> We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
> kernel coding style guidelines. This issue was reported by checkpatch.
>
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

Thanks, applied.

Cheers,
Rusty.
