Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaJFP2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:28:12 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:48071 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaJFP2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:28:10 -0400
Date: Mon, 6 Oct 2014 17:28:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 07/15] virtio_net: drop config_enable
Message-ID: <20141006172801.1f2e520e.cornelia.huck@de.ibm.com>
In-Reply-To: <1412608214-31944-8-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
	<1412608214-31944-8-git-send-email-mst@redhat.com>
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
x-cbid: 14100615-0342-0000-0000-0000014D999C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 18:11:05 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Now that virtio core ensures config changes don't arrive during probing,
> drop config_enable flag in virtio net.
> On removal, flush is now sufficient to guarantee that no change work is
> queued.
> 
> This help simplify the driver, and will allow setting DRIVER_OK earlier
> without losing config change notifications.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

