Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaFQTaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:30:24 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:60453 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbaFQTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:30:23 -0400
Date: Tue, 17 Jun 2014 14:30:21 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Jeff Liu <jeff.liu@oracle.com>
cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/24] sample/kobject: update kset-example code
In-Reply-To: <20140617192256.GE4319@kroah.com>
Message-ID: <alpine.DEB.2.11.1406171428351.22064@gentwo.org>
References: <53A05027.5020407@oracle.com> <20140617192256.GE4319@kroah.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Greg KH wrote:

> On Tue, Jun 17, 2014 at 10:26:47PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > Subject: sample/kobject: update kset-example code
> >
> > Check and return the error ptr if call kset_create_and_add() failed
> >
> > Cc: Christoph Lameter <cl@linux-foundation.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > ---
> >  samples/kobject/kset-example.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Nope, not taking this, sorry.

Ok. I will then accept the first patch to slub.c that you sent which
simply returns -ENOMEM. Please resend that one.

