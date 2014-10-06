Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaJFLs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:48:56 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58539 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaJFLsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:48:53 -0400
Date: Mon, 6 Oct 2014 13:48:45 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 07/16] virtio-blk: drop config_mutex
Message-ID: <20141006134845.157ba74f.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-8-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-8-git-send-email-mst@redhat.com>
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
x-cbid: 14100611-3548-0000-0000-000001C41B58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:07:10 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> config_mutex served two purposes: prevent multiple concurrent config
> change handlers, and synchronize access to config_enable flag.
> 
> Since commit dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1
>     workqueue: make all workqueues non-reentrant
> all workqueues are non-reentrant, and config_enable
> is now gone.
> 
> Get rid of the unnecessary lock.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/block/virtio_blk.c | 8 --------
>  1 file changed, 8 deletions(-)
> 

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

