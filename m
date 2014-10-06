Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaJFPjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:39:35 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50831 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaJFPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:39:30 -0400
Date: Mon, 6 Oct 2014 17:39:20 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 11/15] virtio_net: enable VQs early
Message-ID: <20141006173920.3e66a421.cornelia.huck@de.ibm.com>
In-Reply-To: <1412608214-31944-12-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
	<1412608214-31944-12-git-send-email-mst@redhat.com>
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
x-cbid: 14100615-0342-0000-0000-0000014DA206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 18:11:19 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio spec requires drivers to set DRIVER_OK before using VQs.
> This is set automatically after probe returns, virtio net violated this
> rule by using receive VQs within probe.
> 
> To fix, call virtio_enable_vqs_early before using VQs.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

