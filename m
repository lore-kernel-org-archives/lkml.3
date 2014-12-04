Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbaLDRy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:54:58 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59881 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbaLDRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:54:55 -0500
Date: Thu, 4 Dec 2014 18:54:47 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 1/3] virtio: add API to detect legacy devices
Message-ID: <20141204185447.28e9146d.cornelia.huck@de.ibm.com>
In-Reply-To: <1417713984-23771-1-git-send-email-mst@redhat.com>
References: <1417713984-23771-1-git-send-email-mst@redhat.com>
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
x-cbid: 14120417-0029-0000-0000-00000206C3F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 19:26:42 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> transports need to be able to detect legacy-only
> devices (ATM balloon only) to use legacy path
> to drive them.
> 
> Add a core API to do just that.
> The implementation just blacklists balloon:
> not too pretty, but let's not over-engineer.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h  | 2 ++
>  drivers/virtio/virtio.c | 6 ++++++
>  2 files changed, 8 insertions(+)

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

