Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaLJRmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:42:47 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:57297 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaLJRmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:42:45 -0500
Date: Wed, 10 Dec 2014 18:42:38 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] virtio_ccw: minor enhancements
Message-ID: <20141210184238.12725264.cornelia.huck@de.ibm.com>
In-Reply-To: <20141209185035.GA19260@redhat.com>
References: <1418133187-12436-1-git-send-email-mst@redhat.com>
	<20141209182753.632da537.cornelia.huck@de.ibm.com>
	<20141209185035.GA19260@redhat.com>
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
x-cbid: 14121017-0013-0000-0000-0000022B35A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014 20:50:35 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Dec 09, 2014 at 06:27:53PM +0100, Cornelia Huck wrote:
> > On Tue, 9 Dec 2014 15:53:32 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > Two enhancements for virtio_ccw, on top of latest 1.0 patchset
> > > 
> > > Cornelia Huck (1):
> > >   virtio_ccw: finalize_features error handling
> > > 
> > > Michael S. Tsirkin (1):
> > >   virtio_ccw: future-proof finalize_features
> > > 
> > >  drivers/s390/kvm/virtio_ccw.c | 18 +++++++++++-------
> > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > 
> > 
> > I tried to run this as a guest kernel with my virtio-1 qemu branch +
> > your revision patch on top and it at least boots :) More testing
> > tomorrow.
> 
> It's best if you pick my tree from git.
> vhost-next branch.
> 

FWIW: Your current vhost-next branch + my qemu with the known bugs
seems to hold up well so far; the endianness swap does not seem to
cause a noticeable performance hit (the problems come from my qemu code
dropping feature bits...)

Take this with a grain of salt as current qemu virtio-1 has known
problems, but I don't think there are major reasons speaking against
inclusion. At least, I don't think there's anything in there we can't
easily fix up later.

