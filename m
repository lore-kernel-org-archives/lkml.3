Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaKZJUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:20:14 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:49488 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaKZJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:20:11 -0500
Date: Wed, 26 Nov 2014 10:19:57 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, Pawel Moll <pawel.moll@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 11/42] virtio: add legacy feature table support
Message-ID: <20141126101957.6bd6989c.cornelia.huck@de.ibm.com>
In-Reply-To: <20141125213942.GD22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-12-git-send-email-mst@redhat.com>
	<20141125185342.761bf72e.cornelia.huck@de.ibm.com>
	<20141125213942.GD22343@redhat.com>
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
x-cbid: 14112609-0009-0000-0000-00000224D629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 23:39:42 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Nov 25, 2014 at 06:53:42PM +0100, Cornelia Huck wrote:
> > On Tue, 25 Nov 2014 18:42:09 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:

> > > -	dev->features = driver_features & device_features;
> > > +	/* Some drivers have a separate feature tables for virtio v1.0 */
> > 
> > /* some drivers have a separate feature table for legacy virtio */
> > 
> > ?
> 
> I prefer have separate feature tables:  drivers (plural) have tables
> (plural).
> 
> Agree?

Yes, provided you drop the 'a' :)

