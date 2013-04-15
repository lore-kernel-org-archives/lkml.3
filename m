Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3DOIcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:32:21 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:33210 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3DOIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:32:19 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] base/core.c: improve comment of the function device_find_child()
Date: Mon, 15 Apr 2013 10:32:16 +0200
Message-ID: <2118225.n4e7fofQ54@harkonnen>
User-Agent: KMail/4.10.1 (Linux/3.8.5-201.fc18.x86_64; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130412215125.GA16042@kroah.com>
References: <1365767972-23727-1-git-send-email-federico.vaga@gmail.com> <20130412215125.GA16042@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 April 2013 14:51:25 Greg Kroah-Hartman wrote:
> On Fri, Apr 12, 2013 at 01:59:32PM +0200, Federico Vaga wrote:
> > Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> > ---
> > 
> >  drivers/base/core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 016312437..eb0c6ea 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -1372,6 +1372,10 @@ int device_for_each_child(struct device *parent,
> > void *data,> 
> >   * if it does.  If the callback returns non-zero and a reference to the
> >   * current device can be obtained, this function will return to the
> >   caller
> >   * and not iterate over any more devices.
> > 
> > + *
> > + * NOTE: internally, the function does get_device() on the retrieved
> > child. + * It is duty of the caller performing a put_device() on the
> > retrieved + * child device when the caller finishes to work on it.
> > 
> >   */
> 
> Why not just use the same wording that class_find_device() has, which is
> simpler and easier to understand (IMHO)?

Mh, yes. You are right. I'll send a new patch

-- 
Federico Vaga
