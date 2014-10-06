Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaJFP3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:29:54 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:55854 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaJFP3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:29:52 -0400
Date: Mon, 6 Oct 2014 17:29:42 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 10/15] virtio: add API to enable VQs early
Message-ID: <20141006172942.12271379.cornelia.huck@de.ibm.com>
In-Reply-To: <1412608214-31944-11-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
	<1412608214-31944-11-git-send-email-mst@redhat.com>
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
x-cbid: 14100615-5024-0000-0000-0000018D9DD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 18:11:16 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio spec 0.9.X requires DRIVER_OK to be set before
> VQs are used, but some drivers use VQs before probe
> function returns.
> Since DRIVER_OK is set after probe, this violates the spec.
> 
> Even though under virtio 1.0 transitional devices support this
> behaviour, we want to make it possible for those early callers to become
> spec compliant and eventually support non-transitional devices.
> 
> Add API for drivers to call before using VQs.
> 
> Sets DRIVER_OK internally.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_config.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

