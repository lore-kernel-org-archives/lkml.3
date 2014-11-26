Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaKZJOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:14:07 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46687 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaKZJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:14:00 -0500
Date: Wed, 26 Nov 2014 10:13:49 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 07/42] virtio_config: endian conversion for v1.0
Message-ID: <20141126101349.72debe9d.cornelia.huck@de.ibm.com>
In-Reply-To: <20141125213614.GB22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-8-git-send-email-mst@redhat.com>
	<20141125184557.1e171669.cornelia.huck@de.ibm.com>
	<20141125213614.GB22343@redhat.com>
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
x-cbid: 14112609-0009-0000-0000-00000224CDAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 23:36:14 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Nov 25, 2014 at 06:45:57PM +0100, Cornelia Huck wrote:
> > On Tue, 25 Nov 2014 18:41:52 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > We (ab)use virtio conversion functions for device-specific
> > > config space accesses.
> > > 
> > > Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > This looks odd with the various sign-offs but you as author...
> 
> Signoff tracks all contributors for developer's certificate
> of origin purposes.
> 
> Looking at the patch itself, not a single line (except the subject) seems
> to be shared with the original patch by Rusty that was posted with the
> same subject, so I guess I could have dropped them here, but as I
> refactor code I usually keep all signoffs around as a matter of policy.
> 
> Would you like yours to be dropped then?

Yes, I don't think it really makes sense anymore, as there's no code
left.

I also think David's r-b does not apply anymore, does it?

