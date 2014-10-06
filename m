Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaJFKec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:34:32 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42733 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaJFKe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:34:29 -0400
Date: Mon, 6 Oct 2014 12:34:19 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 03/16] virtio: refactor to use drv_to_virtio
Message-ID: <20141006123419.46a122b5.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-4-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-4-git-send-email-mst@redhat.com>
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
x-cbid: 14100610-5024-0000-0000-0000018C57B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:06:59 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Use drv_to_virtio instead of open-coding it.
> Fix whitespace damage introduced by
>         virtio: unify config_changed handling

Would it make sense to merge this into the previous patch?

> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

