Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3EVS13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:27:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33938 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab3EVS11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:27:27 -0400
Date: Wed, 22 May 2013 13:24:47 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        tpmdd-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        LeonidasDaSilvaBarbosa <leosilva@linux.vnet.ibm.com>,
        AshleyLai <ashley@ashleylai.com>, Peter.Huewe@infineon.com
Subject: Re: [PATCH] maintainers: Remove Kent from maintainers
Message-ID: <20130522182447.GB6818@ennui.austin.ibm.com>
References: <20130522155658.GA3740@ennui.austin.ibm.com>
 <1369240640.2143.74.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369240640.2143.74.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052218-7182-0000-0000-000006D55628
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 09:37:20AM -0700, Joe Perches wrote:
> On Wed, 2013-05-22 at 10:56 -0500, Kent Yoder wrote:
> 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -3971,7 +3971,8 @@ S:	Maintained
> >  F:	arch/ia64/
> >  
> >  IBM Power in-Nest Crypto Acceleration
> > -M:	Kent Yoder <key@linux.vnet.ibm.com>
> > +M:	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> > +M:	Fionnuala Gunter <fin@linux.vnet.ibm.com>
> >  L:	linux-crypto@vger.kernel.org
> >  S:	Supported
> >  F:	drivers/crypto/nx/
> > @@ -8212,7 +8213,8 @@ S:	Odd fixes
> >  F:	drivers/media/usb/tm6000/
> >  
> >  TPM DEVICE DRIVER
> > -M:	Kent Yoder <key@linux.vnet.ibm.com>
> > +M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
> > +M:	Ashley Lai <ashley@ashleylai.com>
> >  M:	Rajiv Andrade <mail@srajiv.net>
> >  W:	http://tpmdd.sourceforge.net
> >  M:	Marcel Selhorst <tpmdd@selhorst.net>
> 
> As far as I know, none of these people have
> previously submitted a single patch.
> 
> None of them were cc'd neither. (now cc'd)
> 
> I think a better way to do this sort of
> change is to have the people becoming
> MAINTAINERS submit the patches and the
> person departing ack it, or simply to
> remove yourself and let other people add
> themselves later.

  Hi Joe,

  Works for me...  I'll submit a new patch removing myself. The tpmdd
list will be monitored by the same folks in the meantime.

  If prior experience is an issue I'd nominate Peter Huewe if he's
interested for tpmdd. For the crypto accelerators though, we have nobody
else...

Kent

> 
> 

