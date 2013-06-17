Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3FQXfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:35:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3FQXfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:35:13 -0400
Date: Mon, 17 Jun 2013 16:35:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, juan.david.gonzalez.cobas@cern.ch,
        cota@braap.org, siglesias@igalia.com, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] FMC: create drivers/fmc and toplevel Kconfig question
Message-ID: <20130617233512.GA14084@kroah.com>
References: <20130617231732.GC12984@kroah.com>
 <cover.1371018406.git.rubini@gnudd.com>
 <8dd3427d60e01c3e7a6eceb7dfd72d5a896b5008.1371018406.git.rubini@gnudd.com>
 <20130617232435.GA17053@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617232435.GA17053@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 01:24:35AM +0200, Alessandro Rubini wrote:
> > Nice job :)
> 
> thanks!
>  
> > Want me to take this through my char/misc git tree to get to Linus for
> > 3.11?
> 
> Would be great. As for the license issue, shall I send the two patches alone
> or the whole set?

Just redo those two patches and send them as 'v2'.  Make sure it was
only those two patches that had the license like that.

thanks,

greg k-h
