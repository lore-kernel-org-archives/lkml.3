Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaJWL5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:57:31 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:60974 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbaJWL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:57:27 -0400
Date: Thu, 23 Oct 2014 13:57:19 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v3 05/16] virtio: add virtio 1.0 feature bit
Message-ID: <20141023135719.0d92dd89.cornelia.huck@de.ibm.com>
In-Reply-To: <1414003404-505-6-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
	<1414003404-505-6-git-send-email-mst@redhat.com>
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
x-cbid: 14102311-0041-0000-0000-000001CA544B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 21:44:31 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Based on original patches by Rusty Russell, Thomas Huth
> and Cornelia Huck.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_config.h | 7 +++++--
>  drivers/virtio/virtio_ring.c       | 2 ++
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

