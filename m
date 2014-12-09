Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaLILYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:24:48 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59845 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbaLILYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:24:47 -0500
Date: Tue, 9 Dec 2014 12:24:39 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, dahi@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 6/6] virtio: drop legacy_only driver flag
Message-ID: <20141209122439.0d040b7e.cornelia.huck@de.ibm.com>
In-Reply-To: <1418042769-25539-7-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
	<1418042769-25539-7-git-send-email-mst@redhat.com>
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
x-cbid: 14120911-0017-0000-0000-00000223C97D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014 15:06:10 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> legacy_only flag is now unused, drop it from core.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h  | 2 --
>  drivers/virtio/virtio.c | 4 ----
>  2 files changed, 6 deletions(-)
> 
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

