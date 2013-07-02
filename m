Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3GBStl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:49:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3GBStk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:49:40 -0400
Date: Tue, 2 Jul 2013 11:49:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Driver Project <devel@linuxdriverproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Staging driver patches for 3.11-rc1
Message-ID: <20130702184939.GA7857@kroah.com>
References: <20130701171759.GA25767@kroah.com>
 <CA+55aFx+RcyqT6smdcH0MOPRRJzUgHtY0t5DD5-EngjePxw0CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx+RcyqT6smdcH0MOPRRJzUgHtY0t5DD5-EngjePxw0CA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 11:43:17AM -0700, Linus Torvalds wrote:
> On Mon, Jul 1, 2013 at 10:17 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:
> >
> >   Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-next
> 
> Hmm. I think you meant the "staging-3.11-rc1" tag, not the
> "staging-next" branch..

Ick, yes, I did, I ran 'git request-pull' before the tag had propagated
out to git.kernel.org, sorry.

thanks,

greg k-h
