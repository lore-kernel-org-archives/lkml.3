Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaLFBkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 20:40:37 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39519 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaLFBkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 20:40:36 -0500
Date: Fri, 5 Dec 2014 23:40:26 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        =?UTF-8?B?R8O8bMWfYWggS8O2c2U=?= <gulsah.1004@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jarod <jarod@wilsonet.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tuomas.tynkkynen" <tuomas.tynkkynen@iki.fi>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] staging: media: lirc: lirc_zilog.c: keep
 consistency in dev functions
Message-ID: <20141205234026.682b3bfb@concha.lan>
In-Reply-To: <CAPA4HGVhKuw6cQHMfRWrTLxd8u3P8a1noAPkzkgrFmsORgXUgw@mail.gmail.com>
References: <20141204223524.GA17650@biggie>
	<20141205122855.GD4912@mwanda>
	<CAPA4HGVhKuw6cQHMfRWrTLxd8u3P8a1noAPkzkgrFmsORgXUgw@mail.gmail.com>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 05 Dec 2014 12:35:25 +0000
Luis de Bethencourt <luis@debethencourt.com> escreveu:

> On 5 December 2014 at 12:28, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > On Thu, Dec 04, 2014 at 10:35:24PM +0000, Luis de Bethencourt wrote:
> > > The previous patch switched some dev functions to move the string to a
> > second
> > > line. Doing this for all similar functions because it makes the driver
> > easier
> > > to read if all similar lines use the same criteria.
> > >
> > > Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> > > ---
> > >  drivers/staging/media/lirc/lirc_zilog.c | 155
> > +++++++++++++++++++++-----------
> > >  1 file changed, 102 insertions(+), 53 deletions(-)
> > >
> > > diff --git a/drivers/staging/media/lirc/lirc_zilog.c
> > b/drivers/staging/media/lirc/lirc_zilog.c
> > > index 8814a7e..af46827 100644
> > > --- a/drivers/staging/media/lirc/lirc_zilog.c
> > > +++ b/drivers/staging/media/lirc/lirc_zilog.c
> > > @@ -322,7 +322,8 @@ static int add_to_buf(struct IR *ir)
> > >       struct IR_tx *tx;
> > >
> > >       if (lirc_buffer_full(rbuf)) {
> > > -             dev_dbg(ir->l.dev, "buffer overflow\n");
> > > +             dev_dbg(ir->l.dev,
> > > +                     "buffer overflow\n");
> >
> > No.  Don't do this.  It's better if it is on one line.
> >
> > regards,
> > dan carpenter
> >
> >
> I was following Mauro's suggestions. As replied to the previous version of
> the patch.
> 
> I agree that in short uses of dev_dbg it adds unnecessary lines and
> vertical length to the file.

In the specific case that Dan pointed, the entire statement fits 
on 80 cols. We only add vertical alignments when it doesn't fit on
80 columns.

> 
> Thanks for looking at my patch :)
> 
> Luis


-- 

Cheers,
Mauro
