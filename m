Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaLALYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:24:13 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:42616 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaLALYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:24:09 -0500
Date: Mon, 1 Dec 2014 12:23:58 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 14/46] virtio: add legacy feature table support
Message-ID: <20141201122358.7c9aee19.cornelia.huck@de.ibm.com>
In-Reply-To: <1417359787-10138-15-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-15-git-send-email-mst@redhat.com>
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
x-cbid: 14120111-0021-0000-0000-000001F8EF47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 17:10:26 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio-blk has some legacy feature bits that modern drivers
> must not negotiate, but are needed for old legacy hosts
> (that e.g. don't support virtio-scsi).
> Allow a separate legacy feature table for such cases.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h  |  4 ++++
>  drivers/virtio/virtio.c | 25 ++++++++++++++++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

