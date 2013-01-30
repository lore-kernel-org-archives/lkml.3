Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3A3KFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:05:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:48843 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3A3KFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:05:04 -0500
Date: Wed, 30 Jan 2013 11:06:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dirkjan Bussink <dirkjan.bussink@nedap.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Prevent deadlock in n_gsm driver
Message-ID: <20130130100655.GA31575@kroah.com>
References: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
 <20130130051213.GA26675@kroah.com>
 <E78C7BE9-BB39-409D-B2F9-4DAB81BE9513@nedap.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E78C7BE9-BB39-409D-B2F9-4DAB81BE9513@nedap.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:55:00AM +0100, Dirkjan Bussink wrote:
> 
> On 30 Jan 2013, at 06:12, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > It doesn't apply cleanly to the linux-next tree, can you refresh this
> > and resend it so that I can apply it?  If you want it backported to the
> > stable kernel releases, we can only do that after it gets into Linus's
> > tree, see the file, Documentation/stable_kernel_rules.txt for details
> > about this.
> 
> I've reapplied the patch to linux-next and submitted it just now. Is there
> anything additionally that needs to be done to merge this back to stable
> after this patch is applied? 

You need to add a "cc: stable@vger.kernel.org" line to the
signed-off-by: area.  I'll do it to the patch when I apply it.

I found the problem, your email client stripped out the trailing spaces
of the patch, which kept it from being applied as it wasn't a valid
patch.  I've edited it by hand this time, but next time please fix your
email client.

thanks,

greg k-h
