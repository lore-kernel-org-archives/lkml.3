Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaK1Iyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:54:51 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:41934 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaK1Iyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:54:50 -0500
Date: Fri, 28 Nov 2014 09:54:36 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 05/46] virtio: assert 32 bit features in transports
Message-ID: <20141128095436.20c59e84@thinkpad-w530>
In-Reply-To: <1417118789-18231-6-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-6-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112808-0025-0000-0000-000002A1BEAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At this point, no transports set any of the high 32 feature bits.
> Since transports generally can't (yet) cope with such bits, add BUG_ON
> checks to make sure they are not set by mistake.
> 
> Based on rproc patch by Rusty.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/lguest/lguest_device.c         | 3 +++
>  drivers/misc/mic/card/mic_virtio.c     | 3 +++
>  drivers/remoteproc/remoteproc_virtio.c | 3 +++
>  drivers/s390/kvm/kvm_virtio.c          | 3 +++
>  drivers/s390/kvm/virtio_ccw.c          | 3 +++
>  drivers/virtio/virtio_mmio.c           | 3 +++
>  drivers/virtio/virtio_pci.c            | 3 +++
>  7 files changed, 21 insertions(+)
> 

Looks sane to me.

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>

