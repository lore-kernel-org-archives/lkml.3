Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaLIKfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:35:38 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50570 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaLIKfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:35:36 -0500
Date: Tue, 9 Dec 2014 11:35:29 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, dahi@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, Christian Borntraeger <borntraeger@de.ibm.com>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/6] virtio_ccw: legacy: don't negotiate rev
 1/features
Message-ID: <20141209113529.675e8df3.cornelia.huck@de.ibm.com>
In-Reply-To: <1418042769-25539-3-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
	<1418042769-25539-3-git-send-email-mst@redhat.com>
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
x-cbid: 14120910-0013-0000-0000-00000224C7D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014 15:05:54 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Legacy balloon device doesn't pretend to support revision 1 or 64 bit
> features.
> 
> But just in case someone implements a broken one that does, let's not
> even try to drive legacy only devices using revision 1, and let's not
> give them a chance to say they support VIRTIO_F_VERSION_1 by not reading

s/reading/reading or writing/

> high feature bits.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Otherwise, looks good.

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

