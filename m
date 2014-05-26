Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEZA0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 20:26:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEZA0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 20:26:14 -0400
Date: Sun, 25 May 2014 17:26:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: andreas.dilger@intel.com, Oleg Drokin <green@linuxhacker.ru>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: lustre: lnet: klnds: Fix coding style in
 socklnd.c
Message-ID: <20140526002612.GA31606@kroah.com>
References: <1401056652-596-1-git-send-email-massa.nomura@gmail.com>
 <20140525223719.GA24682@kroah.com>
 <CAAvxhqCX=PmSerzQZKdpUQCiehhEeGDs1RN1woYL_oJ++EkzQg@mail.gmail.com>
 <20140525233039.GA28206@kroah.com>
 <CAAvxhqDR5mv2Z=Wz5kZPrUBzhMJCJjUuhce_CUc4fMubGAxttA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAvxhqDR5mv2Z=Wz5kZPrUBzhMJCJjUuhce_CUc4fMubGAxttA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:57:39AM +0100, Masaru Nomura wrote:
> > What _branch_ of that git tree did you make it against?
> >
> 
> I did my work against
> 
> commit 4b660a7f5c8099d88d1a43d8ae138965112592c7

That is a commit, not a branch.

Please work against the staging-next branch, not master.  master
reflects Linus's tree.

thanks,

greg k-h
