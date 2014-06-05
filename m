Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaFEJXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:23:40 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:41455 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaFEJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:23:38 -0400
Subject: Re: [PATCH 4/4] GenWQE: Increase driver version number
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140604155454.GA2866@kroah.com>
References: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
	 <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
	 <20140604155454.GA2866@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 05 Jun 2014 11:23:04 +0200
Message-ID: <1401960184.11932.10.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060509-8372-0000-0000-0000001704C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 04.06.2014, 08:54 -0700 schrieb Greg KH:
> On Wed, Jun 04, 2014 at 10:57:53AM -0300, Kleber Sacilotto de Souza wrote:
> > Increase genwqe driver version number.
> > 
> > Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> > ---
> >  drivers/misc/genwqe/genwqe_driver.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
> > index cd52631..a506e9a 100644
> > --- a/drivers/misc/genwqe/genwqe_driver.h
> > +++ b/drivers/misc/genwqe/genwqe_driver.h
> > @@ -36,7 +36,7 @@
> >  #include <asm/byteorder.h>
> >  #include <linux/genwqe/genwqe_card.h>
> >  
> > -#define DRV_VERS_STRING		"2.0.15"
> > +#define DRV_VERS_STRING		"2.0.21"
> 
> Why is this even needed?  Can't you go off of the kernel version number
> now?  Who needs / wants this number?

I am aware that if just considering the mainline kernels, we could use
the kernel version itself for the purpose of identifying which code we
are running.

But in our lab we are running multiple back-ported versions of this
driver on different Linux distributions using different kernel versions.
Our user-space software needs to know if the driver has or has not
bug-fixes or features. For this purpose, we are using this extra number.

> thanks,
> 
> greg k-h
> 

Regards

Frank

