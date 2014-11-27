Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaK0KOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:14:53 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:44833 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaK0KOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:14:50 -0500
Date: Thu, 27 Nov 2014 12:14:40 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Steven Walter <stevenrwalter@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Bluetooth: automatically flushable packets aren't
 allowed on LE links
Message-ID: <20141127101440.GA11656@t440s>
Mail-Followup-To: Marcel Holtmann <marcel@holtmann.org>,
	Steven Walter <stevenrwalter@gmail.com>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	BlueZ development <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1416419951-27659-1-git-send-email-stevenrwalter@gmail.com>
 <20141120113813.GA23288@t440s.lan>
 <80321467-10AB-489E-A47E-44B0ECEE4BE1@holtmann.org>
 <CAK8d-aL+3eB4WZeqO1sv9p3440EVXQiqF6QiTU5YNAKAbZ7f-w@mail.gmail.com>
 <CAK8d-a+MJBBLkU_=UQGKVmxnM-sYJ=pW7aj0XQ5aa5AuR2G_Wg@mail.gmail.com>
 <50D951D4-0A99-4D77-814C-D80A209B3D4F@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D951D4-0A99-4D77-814C-D80A209B3D4F@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Wed, Nov 26, 2014, Marcel Holtmann wrote:
> >>>> I think Marcel was after just providing a clarifying code comment in
> >>>> both places - having two branches of an if-statement doing exactly the
> >>>> same thing looks a bit weird to me. To make thins completely clear I'd
> >>>> suggest adding a simple helper function that you can call from both
> >>>> places to get the needed flags, something like the following:
> >>> 
> >>> I am actually fine with just adding a comment explaining the complex if
> >>> statement on why it is correct. It is just a helper for everybody to
> >>> understand what and why it is done that way.
> >> 
> >> 
> >> Is the comment I added sufficient, or should I add one for the other if
> >> condition as well?  To me, the second condition is pretty straightforward:
> >> if the caller requested it and the hardware supports it, use NO_FLUSH.  The
> >> relationship between FLUSH/NO_FLUSH and low-energy is much less clear and
> >> more justifies a comment, in my opinion.
> > 
> > Did a miss a reply to this?  How would you like the next iteration of
> > the patch to look?
> 
> can you just send a v4 and I have a look at it. I thing it is best to
> keep the original patch with the rather complicated if statement you
> had. And then add a comment in front of it, why it is that way and
> that it is correct this way.

Since this is moving way too slow for such a trivial patch I went ahead
and added the necessary comments myself and pushed the patch upstream
(to bluetooth-next). So no need to send new revisions of this one.

Johan
