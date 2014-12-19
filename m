Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaLSBiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:38:52 -0500
Received: from ozlabs.org ([103.22.144.67]:37077 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaLSBiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:38:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/6] virtio 1.0 fixups, tweaks
In-Reply-To: <1418678575-31755-1-git-send-email-mst@redhat.com>
References: <1418678575-31755-1-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Dec 2014 11:56:54 +1030
Message-ID: <87sigcsa3l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Fixes a couple of minor compliance issues in new virtio 1.0 code.
> Plus, adds a couple of minor cleanups - not bugfixes,
> but seem safe enough for 3.19.

OK, I've applied these.

Thanks,
Rusty.

> Michael S. Tsirkin (6):
>   virtio: set VIRTIO_CONFIG_S_FEATURES_OK on restore
>   virtio_config: fix virtio_cread_bytes
>   virtio_pci_common.h: drop VIRTIO_PCI_NO_LEGACY
>   virtio_pci: move probe to common file
>   virtio_pci: add VIRTIO_PCI_NO_LEGACY
>   virtio: core support for config generation
>
>  drivers/virtio/virtio_pci_common.h |  7 +++----
>  include/linux/virtio_config.h      | 29 ++++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_pci.h    | 15 ++++++++++-----
>  drivers/virtio/virtio.c            | 37 +++++++++++++++++++++++--------------
>  drivers/virtio/virtio_pci_common.c | 34 +++++++++++++++++++++++++++++++++-
>  drivers/virtio/virtio_pci_legacy.c | 24 ++----------------------
>  6 files changed, 99 insertions(+), 47 deletions(-)
>
> -- 
> MST
