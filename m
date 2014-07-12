Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaGLAwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:52:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaGLAwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:52:10 -0400
Date: Fri, 11 Jul 2014 17:56:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Cristian Stoica <cristian.stoica@freescale.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: devres: update list of supported calls
Message-ID: <20140712005638.GA10022@kroah.com>
References: <1404720626-20841-1-git-send-email-cristian.stoica@freescale.com>
 <53BF1F06.60609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BF1F06.60609@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 04:17:26PM -0700, Randy Dunlap wrote:
> On 07/07/2014 01:10 AM, Cristian Stoica wrote:
> > Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> 
> Greg, do you want this patch?
> 
> > ---
> >  Documentation/driver-model/devres.txt | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> > index 1525e30..7a48896 100644
> > --- a/Documentation/driver-model/devres.txt
> > +++ b/Documentation/driver-model/devres.txt
> > @@ -234,6 +234,7 @@ certainly invest a bit more effort into libata core layer).
> >    -----------------------------
> >  
> >  MEM
> > +  devm_kmalloc()
> >    devm_kzalloc()
> >    devm_kfree()
> >    devm_kmemdup()

It's already in my tree in another form, so it doesn't make sense for me
to take it again...

thanks,

greg k-h
