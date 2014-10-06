Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaJFMGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:06:52 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:34728 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaJFMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:06:49 -0400
Date: Mon, 6 Oct 2014 14:06:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 11/16] virtio_net: minor cleanup
Message-ID: <20141006140640.36ff345f.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-12-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-12-git-send-email-mst@redhat.com>
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
x-cbid: 14100612-8372-0000-0000-0000016D3DB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:07:21 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> 	goto done;
> done:
> 	return;
> is ugly, it was put there to make diff review easier.
> replace by open-coded return.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

If you don't want to merge it into the mutex removal patch, maybe move
it one up in the series?

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

