Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaKYR5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:57:25 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:50050 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaKYR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:57:22 -0500
Date: Tue, 25 Nov 2014 18:57:16 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 16/42] KVM: s390 allow virtio_ccw status writes to
 fail
Message-ID: <20141125185716.0af7e4b0.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-17-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-17-git-send-email-mst@redhat.com>
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
x-cbid: 14112517-0029-0000-0000-000001DD44E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:32 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

missing colon after "s390" in subject

> Gracefully handle failure to write device status.
> We really should handle other errors as well, but this one is needed for
> virtio 1.0 compliance.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

