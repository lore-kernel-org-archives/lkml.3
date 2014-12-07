Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaLGUsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:48:43 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61674 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaLGUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:48:14 -0500
Date: Sun, 7 Dec 2014 12:48:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/20] USB: isp1760: fix misspelling of current function
 in string
Message-ID: <20141207204811.GC5360@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417980062-25151-9-git-send-email-Julia.Lawall@lip6.fr>
 <20141207204138.GA5360@hudson.localdomain>
 <alpine.DEB.2.02.1412072143460.2235@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412072143460.2235@localhost6.localdomain6>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia,

On Sun, Dec 07, 2014 at 09:45:15PM +0100, Julia Lawall wrote:
> 
> 
> On Sun, 7 Dec 2014, Jeremiah Mahler wrote:
> 
> > Julia,
> > 
> > On Sun, Dec 07, 2014 at 08:20:50PM +0100, Julia Lawall wrote:
> > > Replace a misspelled function name by %s and then __func__.
[...]
> > >  
> > >  static void isp1761_pci_shutdown(struct pci_dev *dev)
> > >  {
> > > -	printk(KERN_ERR "ips1761_pci_shutdown\n");
> > > +	printk(KERN_ERR "%s\n", __func__);
> > >  }
> > >  
> > You can also switch from printk to pr_err and that would fix thte
> > checkpatch warning for this patch.
> 
> Yeah, I didn't want to do too much at once, since tha could be done all at 
> once in a lot of other places too.  But I will fix up this one.
> 
> julia
> 

I agree, doing too much at once is usually bad.  But these are pretty
small and it is good if your patch doesn't have any checkpatch issues.

> > >  static const struct pci_device_id isp1760_plx [] = {
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > -- 
> > - Jeremiah Mahler
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

-- 
- Jeremiah Mahler
