Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704AbaGXUnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:43:42 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34698 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:43:41 -0400
MIME-Version: 1.0
Date: Thu, 24 Jul 2014 13:43:39 -0700
Message-ID: <CAF8JNhJypqDf_1e1heza8G_faPhtyKqxS19dg+_+AEFYvWCeuw@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] Input - wacom: handle Graphire BT tablets in wacom.ko
From: Ping Cheng <pinglinux@gmail.com>
To: linux-input <linux-input@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:58 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Thu, Jul 24, 2014 at 03:43:52PM -0400, Benjamin Tissoires wrote:
> > On Jul 24 2014 or thereabouts, Dmitry Torokhov wrote:
> > > Hi Benjamin,
> > >
> > > On Thu, Jul 24, 2014 at 02:14:02PM -0400, Benjamin Tissoires wrote:
> > > > +                 } else if (features->type == GRAPHIRE_BT) {
> > > > +                         /* Compute distance between mouse and tablet */
> > > > +                         rw = 44 - (data[6] >> 2);
> > > > +                         if (rw < 0)
> > > > +                                 rw = 0;
> > > > +                         else if (rw > 31)
> > > > +                                 rw = 31;
> > >
> > >                             rw = clamp_val(rw, 0, 31);
> > >
> > > ?
> >
> > could be...
> >
> > I'll do the tests and resubmit later the v3. I'll wait a little in case
> > you have other comments on the other patches :)
>
> How about doing it incrementally - the patch is still sound as far as I
> am concerned. I will wait a bit for other to chime in with comments or
> acks before applying this series.


Thank you Benjamin and Dmitry for your support. The whole series is:

Acked-by: Ping Cheng <pingc@wacom.com>

Cheers,

Ping
