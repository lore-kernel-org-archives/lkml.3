Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaLAH5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:57:55 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42730 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaLAH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:57:54 -0500
Date: Mon, 1 Dec 2014 08:57:46 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 10/46] virtio_config: endian conversion for v1.0
Message-ID: <20141201085746.4de677a8@thinkpad-w530>
In-Reply-To: <1417359787-10138-11-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-11-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120107-0009-0000-0000-000002342951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We (ab)use virtio conversion functions for device-specific
> config space accesses.
> 
> Based on original patches by Cornelia and Rusty.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Reviewed-by: David Hildenbrand <dahi@linux.vnet.com>

