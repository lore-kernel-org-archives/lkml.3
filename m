Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab3EBCE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:04:29 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56530 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3EBCE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:04:27 -0400
Message-ID: <1367460419.23900.20.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 0/3] vhost-scsi: file renames
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Asias He <asias@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Date: Wed, 01 May 2013 19:06:59 -0700
In-Reply-To: <cover.1367459045.git.mst@redhat.com>
References: <cover.1367459045.git.mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 04:45 +0300, Michael S. Tsirkin wrote:
> This reorgs the files a bit, renaming tcm_vhost to
> vhost_scsi as that's how userspace refers to it.
> While at it, cleanup some leftovers from when it was a
> staging driver.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> 

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

Thanks MST!

> Michael S. Tsirkin (3):
>   vhost: src file renames
>   tcm_vhost: header split up
>   vhost_scsi: module rename
> 
>  drivers/vhost/Kconfig                 |  10 ++-
>  drivers/vhost/Kconfig.tcm             |   6 --
>  drivers/vhost/Makefile                |   3 +-
>  drivers/vhost/{tcm_vhost.c => scsi.c} | 115 ++++++++++++++++++++++++++---
>  drivers/vhost/tcm_vhost.h             | 131 ----------------------------------
>  include/uapi/linux/vhost.h            |  28 ++++++++
>  6 files changed, 143 insertions(+), 150 deletions(-)
>  delete mode 100644 drivers/vhost/Kconfig.tcm
>  rename drivers/vhost/{tcm_vhost.c => scsi.c} (94%)
>  delete mode 100644 drivers/vhost/tcm_vhost.h
> 


