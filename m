Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaLAMkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:40:47 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59585 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaLAMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:40:45 -0500
Date: Mon, 1 Dec 2014 13:40:36 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Message-ID: <20141201134036.726e7386.cornelia.huck@de.ibm.com>
In-Reply-To: <20141201123455.GA17958@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092658.GC15607@redhat.com>
	<20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
	<20141201114645.GA17505@redhat.com>
	<20141201130258.6f01c1e3.cornelia.huck@de.ibm.com>
	<20141201123455.GA17958@redhat.com>
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
x-cbid: 14120112-0029-0000-0000-000001F540EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 14:34:55 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Dec 01, 2014 at 01:02:58PM +0100, Cornelia Huck wrote:
> > On Mon, 1 Dec 2014 13:46:45 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > On Mon, Dec 01, 2014 at 12:33:15PM +0100, Cornelia Huck wrote:
> > > > On Mon, 1 Dec 2014 11:26:58 +0200
> > > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > 
> > > > > For some places on data path, it might be worth it
> > > > > to cache the correct value e.g. as part of device
> > > > > structure. This replaces a branch with a memory load,
> > > > > so the gain would have to be measured, best done
> > > > > separately?
> > > > 
> > > > I think we'll want to do some measuring once the basic structure is
> > > > in place anyway.
> > > 
> > > What's meant by in place here?
> > 
> > That this patchset is ready :)
> 
> Also it's ready to the level where benchmarking is possible, right?  I
> don't think you should wait until we finish polishing up commit
> messages.

My point is that I haven't even found time yet to test this
thouroughly :(

