Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaK1KJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:09:21 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:35256 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaK1KJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:09:18 -0500
Date: Fri, 28 Nov 2014 11:09:10 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 20/46] KVM: s390: enable virtio-ccw revision 1
Message-ID: <20141128110910.123a1c62.cornelia.huck@de.ibm.com>
In-Reply-To: <1417118789-18231-21-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-21-git-send-email-mst@redhat.com>
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
x-cbid: 14112810-0009-0000-0000-0000022D2761
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 22:09:30 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> Now that virtio-ccw has everything needed to support virtio 1.0 in
> place, try to enable it if the host supports it.
> 
> MST: enable virtio 1.0 feature bit

Stale comment?

> 
> Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> index 79f6737..8ec68dd 100644
> --- a/drivers/s390/kvm/virtio_ccw.c
> +++ b/drivers/s390/kvm/virtio_ccw.c
> @@ -103,7 +103,7 @@ struct virtio_rev_info {
>  };
> 
>  /* the highest virtio-ccw revision we support */
> -#define VIRTIO_CCW_REV_MAX 0
> +#define VIRTIO_CCW_REV_MAX 1
> 
>  struct virtio_ccw_vq_info {
>  	struct virtqueue *vq;

