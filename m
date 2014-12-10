Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321AbaLJWfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:35:00 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35141 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbaLJWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:34:58 -0500
Date: Wed, 10 Dec 2014 14:34:54 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for Dec 10
Message-ID: <20141210223454.GA4726@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20141210204822.3359b7ef@canb.auug.org.au>
 <20141210113014.GB10836@hudson.localdomain>
 <20141211075142.5fe2993a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211075142.5fe2993a@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Thu, Dec 11, 2014 at 07:51:42AM +1100, Stephen Rothwell wrote:
> Hi Jeremiah,
> 
> On Wed, 10 Dec 2014 03:30:14 -0800 Jeremiah Mahler <jmmahler@gmail.com> wrote:
> >
> > Just a FYI.
> > 
> > As of -next 20141210 commit d32394fae95741d733b174ec1446f27765f80233,
> > which caused a suspend hang bug [1], is still in the tree.  Greg created
> > a revert patch for it in driver-core [2] but I am not sure if this will
> > make its way to -next.
> > 
> >   [1]: https://lkml.org/lkml/2014/12/3/215
> > 
> >   [2]: https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/commit/?h=driver-core-testing&id=f1c488a78d9f1a22cdb15648c15e70fd82ed229a
> 
> Unfortunately, I can't control how often maintainers update the
> versions of their trees that are included in linux-next :-(
> 

Ah, I see.
Next time I will pester the maintainers :-)

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

-- 
- Jeremiah Mahler
