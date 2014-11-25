Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaKYRzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:55:24 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:55937 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaKYRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:55:23 -0500
Date: Tue, 25 Nov 2014 18:55:16 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Thomas Huth <thuth@linux.vnet.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 13/42] virtio_blk: v1.0 support
Message-ID: <20141125185516.7570c6e7.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-14-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-14-git-send-email-mst@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112517-0025-0000-0000-000002938E1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:18 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Based on patch by Cornelia Huck.
> 
> Note: for consistency, and to avoid sparse errors,
>       convert all fields, even those no longer in use
>       for virtio v1.0.
> 
> Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
> Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_blk.h | 15 ++++-----
>  drivers/block/virtio_blk.c      | 70 ++++++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 36 deletions(-)
> 

Is this sufficiently unchanged so that the original r-bs still hold?

