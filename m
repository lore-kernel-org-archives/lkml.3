Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaKYJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:06:00 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33275 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaKYJFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:05:55 -0500
Date: Tue, 25 Nov 2014 10:05:40 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/41] linux: towards virtio-1 guest support
Message-ID: <20141125100540.3b747d12.cornelia.huck@de.ibm.com>
In-Reply-To: <20141124191205.GA8049@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
	<20141124194831.252318e4.cornelia.huck@de.ibm.com>
	<20141124191205.GA8049@redhat.com>
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
x-cbid: 14112509-0005-0000-0000-000002363CF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 21:12:05 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Nov 24, 2014 at 07:48:31PM +0100, Cornelia Huck wrote:

> > vring_transport_features() seems to knock off the version 1 bit (I
> > wonder why I did not see that before, maybe VIRTIO_TRANSPORT_F_END had
> > not been increased before?). If I add VIRTIO_F_VERSION_1 in this
> > function, virtio-net and virtio-blk seem to work fine with version 1 on
> > virtio-ccw (tested with my old virtio-1 qemu branch).
> 
> What if we just move VIRTIO_TRANSPORT_F_END back for now?
> Does patch below fix it for you?

It does.

> 
> > I'll try to do a bit of reviewing tomorrow.
> 
> BTW could you post your latest qemu bits please?

I haven't done much work on virtio-1 lately, but I could rebase my
existing branch to current qemu.

