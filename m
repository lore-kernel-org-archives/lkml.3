Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaLAIGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:06:33 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49061 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaLAIGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:06:32 -0500
Date: Mon, 1 Dec 2014 09:06:18 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 13/46] virtio: simplify feature bit handling
Message-ID: <20141201090618.3ca35baa@thinkpad-w530>
In-Reply-To: <1417359787-10138-14-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-14-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120108-0021-0000-0000-000001F8011F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now that we use u64 for bits, we can simply & them together.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>

