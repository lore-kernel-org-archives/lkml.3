Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLIR2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:28:02 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:59262 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaLIR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:28:00 -0500
Date: Tue, 9 Dec 2014 18:27:53 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] virtio_ccw: minor enhancements
Message-ID: <20141209182753.632da537.cornelia.huck@de.ibm.com>
In-Reply-To: <1418133187-12436-1-git-send-email-mst@redhat.com>
References: <1418133187-12436-1-git-send-email-mst@redhat.com>
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
x-cbid: 14120917-0009-0000-0000-000002501F7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014 15:53:32 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Two enhancements for virtio_ccw, on top of latest 1.0 patchset
> 
> Cornelia Huck (1):
>   virtio_ccw: finalize_features error handling
> 
> Michael S. Tsirkin (1):
>   virtio_ccw: future-proof finalize_features
> 
>  drivers/s390/kvm/virtio_ccw.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 

I tried to run this as a guest kernel with my virtio-1 qemu branch +
your revision patch on top and it at least boots :) More testing
tomorrow.

