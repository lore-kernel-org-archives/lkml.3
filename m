Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbaGXQFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:05:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbaGXQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:05:13 -0400
Date: Thu, 24 Jul 2014 09:04:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] usb-core: Revert "usb-core: Remove Fix mes in file hcd.c"
Message-ID: <20140724160447.GC14956@kroah.com>
References: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com>
 <20140723164910.GA8319@kroah.com>
 <53D106C9.8070803@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D106C9.8070803@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 09:14:49AM -0400, Sasha Levin wrote:
> On 07/23/2014 12:49 PM, Greg KH wrote:
> > On Wed, Jul 23, 2014 at 08:56:10AM -0400, Sasha Levin wrote:
> >> > Revert since the commit message is incorrect and the original author refuses
> >> > to fix/maintain it because "it's in the kernel already".
> > How can someone "fix" a commit message that is already in the tree?  You
> > can't.  The code part is correct, so why introduce the issue back?
> 
> (I'm not trying to be aggressive, I just think that I misunderstand how this
> part of the process works exactly).
> 
> I thought we can always edit -next trees? Why do we have to maintain fast forward
> on them?

I can never edit my public trees, because people base their work on
them, and they are public.

> What happens, if for example you take a patch that causes build breakage? Would you
> add a revert after that or just yank the commit out of the tree?

I add a revert, or add a patch that fixes it.

> If you add a revert and leave the original broken commit in, wouldn't it cause issues
> for anyone trying to bisect a build breakage?

Yes it does.

I can not rebase my public trees, nor should any other kernel
maintainer.  This has been true for _many_ years.

greg k-h
