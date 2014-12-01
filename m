Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaLAJJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:09:11 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:38463 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaLAJJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:09:09 -0500
Date: Mon, 1 Dec 2014 10:08:54 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 01/46] virtio: add low-level APIs for feature bits
Message-ID: <20141201100854.2a21b168.cornelia.huck@de.ibm.com>
In-Reply-To: <1417359787-10138-2-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-2-git-send-email-mst@redhat.com>
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
x-cbid: 14120109-0009-0000-0000-000002347387
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 17:09:08 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Add low level APIs to test/set/clear feature bits.
> For use by transports, to make it easier to
> write code independent of feature bit array format.
> 
> Note: APIs is prefixed with __ and has _bit suffix
> to stress its low level nature.  It's for use by transports only:
> drivers should use virtio_has_feature and never need to set/clear
> features.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_config.h | 53 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 3 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

