Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaKZMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:35:37 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42919 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKZMff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:35:35 -0500
Date: Wed, 26 Nov 2014 13:35:24 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 20/42] virtio_net: pass vi around
Message-ID: <20141126133524.27e9beb6.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-21-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-21-git-send-email-mst@redhat.com>
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
x-cbid: 14112612-0041-0000-0000-000002430468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:49 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Too many places poke at [rs]q->vq->vdev->priv just to get
> the the vi structure.  Let's just pass the pointer around: seems

s/the the/the/

> cleaner, and might even be faster.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
Looks reasonable.

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

