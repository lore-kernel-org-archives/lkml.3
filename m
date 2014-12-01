Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaLAIUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:20:49 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:35944 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaLAIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:20:48 -0500
Date: Mon, 1 Dec 2014 09:20:37 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v7 18/46] KVM: s390: virtio-ccw revision 1 SET_VQ
Message-ID: <20141201092037.4c560540@thinkpad-w530>
In-Reply-To: <1417359787-10138-19-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-19-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120108-0017-0000-0000-000002090F07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> The CCW_CMD_SET_VQ command has a different format for revision 1+
> devices, allowing to specify a more complex virtqueue layout. For
> now, we stay however with the old layout and simply use the new
> command format for virtio-1 devices.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 54 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 42 insertions(+), 12 deletions(-)

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>

