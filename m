Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbaLKRXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:23:43 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:54249 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaLKRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:23:41 -0500
Date: Thu, 11 Dec 2014 18:23:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] virtio: set VIRTIO_CONFIG_S_FEATURES_OK on restore
Message-ID: <20141211182334.2ac1897b.cornelia.huck@de.ibm.com>
In-Reply-To: <1418317279-13915-2-git-send-email-mst@redhat.com>
References: <1418317279-13915-1-git-send-email-mst@redhat.com>
	<1418317279-13915-2-git-send-email-mst@redhat.com>
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
x-cbid: 14121117-0041-0000-0000-00000272AB38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 19:01:31 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio 1.0 devices require that drivers set VIRTIO_CONFIG_S_FEATURES_OK
> after finalizing features.
> virtio core missed doing this on restore, fix it up.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio.c | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

