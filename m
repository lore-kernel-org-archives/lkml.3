Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab3EBEoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 00:44:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3EBEoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 00:44:07 -0400
Date: Thu, 2 May 2013 12:44:02 +0800
From: Asias He <asias@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] vhost-scsi: file renames
Message-ID: <20130502044402.GC3646@hj.localdomain>
References: <cover.1367459045.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1367459045.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:45:30AM +0300, Michael S. Tsirkin wrote:
> This reorgs the files a bit, renaming tcm_vhost to
> vhost_scsi as that's how userspace refers to it.
> While at it, cleanup some leftovers from when it was a
> staging driver.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Asias He <asias@redhat.com>

> 
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
> -- 
> MST

-- 
Asias
