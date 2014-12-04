Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaLDQTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:19:13 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44167 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbaLDQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:19:10 -0500
Date: Thu, 4 Dec 2014 17:19:00 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v8 17/50] KVM: s390: Set virtio-ccw transport revision
Message-ID: <20141204171900.3c31bfbe.cornelia.huck@de.ibm.com>
In-Reply-To: <20141204161022.GA23199@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
	<1417449619-24896-18-git-send-email-mst@redhat.com>
	<20141204161022.GA23199@redhat.com>
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
x-cbid: 14120416-0009-0000-0000-00000242D27F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 18:10:22 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Dec 01, 2014 at 06:04:11PM +0200, Michael S. Tsirkin wrote:
> > From: Thomas Huth <thuth@linux.vnet.ibm.com>
> > 
> > With the new SET-VIRTIO-REVISION command of the virtio 1.0 standard, we
> > can now negotiate the virtio-ccw revision after setting a channel online.
> > 
> > Note that we don't negotiate version 1 yet.
> > 
> > [Cornelia Huck: reworked revision loop a bit]
> > Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > Signed-off-by: Thomas Huth <thuth@linux.vnet.ibm.com>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Looking at this some more: to me it looks
> like this command should be repeated whenever we reset
> the device.
> 
> No?

It should, when we re-setup.

