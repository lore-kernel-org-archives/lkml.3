Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbaLDR7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:59:23 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:60964 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaLDR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:59:21 -0500
Date: Thu, 4 Dec 2014 18:59:14 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] virtio_ccw: rev 1 devices set
 VIRTIO_F_VERSION_1
Message-ID: <20141204185914.4e989a7a.cornelia.huck@de.ibm.com>
In-Reply-To: <1417713984-23771-3-git-send-email-mst@redhat.com>
References: <1417713984-23771-1-git-send-email-mst@redhat.com>
	<1417713984-23771-3-git-send-email-mst@redhat.com>
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
x-cbid: 14120417-0029-0000-0000-00000206C757
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 19:26:50 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> What does it mean if rev 1 device does not set
> VIRTIO_F_VERSION_1? E.g. is it native endian?
> 
> Let's not even try to drive such devices:
> skip attempts to finalize features or set status.

Why not set status_failed?

> virtio core will detect this and bail out.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 

I'm not sure yet whether I like this approach. I'll think about it over
the weekend.

