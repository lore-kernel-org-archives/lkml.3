Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaJNHfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:35:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaJNHf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:35:28 -0400
Date: Tue, 14 Oct 2014 09:35:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Frans Klaver <frans.klaver@xsens.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gadget_configfs.txt: fix spelling of 'function'
In-Reply-To: <20141014070012.GC25389@ci00147.xsens-tech.local>
Message-ID: <alpine.LNX.2.00.1410140934080.31343@pobox.suse.cz>
References: <1412170231-30936-1-git-send-email-frans.klaver@xsens.com> <20141014070012.GC25389@ci00147.xsens-tech.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014, Frans Klaver wrote:

> > Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> > ---
> >  Documentation/usb/gadget_configfs.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/usb/gadget_configfs.txt b/Documentation/usb/gadget_configfs.txt
> > index 4cf53e4..635e574 100644
> > --- a/Documentation/usb/gadget_configfs.txt
> > +++ b/Documentation/usb/gadget_configfs.txt
> > @@ -376,7 +376,7 @@ functions and binds them. This way the whole gadget is bound.
> >  configured, so config_groups for particular functions are defined
> >  in the functions implementation files drivers/usb/gadget/f_*.c.
> >  
> > -5. Funciton's code is written in such a way that it uses
> > +5. Function's code is written in such a way that it uses
> >  
> >  usb_get_function_instance(), which, in turn, calls request_module.
> >  So, provided that modprobe works, modules for particular functions
> > -- 
> > 2.1.0
> > 
> 
> Ping

Frans,

your patch hasn't been lost, it's in my 'to-process' queue. It's merge 
window now, plus this is a super-low priority patch. Please be patient, it 
will eventually be processed.

-- 
Jiri Kosina
SUSE Labs
