Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3ILVwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:52:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3ILVwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:52:01 -0400
Date: Thu, 12 Sep 2013 14:52:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/16] 3.11.1-stable review
Message-ID: <20130912215200.GA8630@kroah.com>
References: <20130912181156.173326121@linuxfoundation.org>
 <20130912182240.GA10404@kroah.com>
 <20130912182730.GA11890@kroah.com>
 <201309122142.06194.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309122142.06194.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 09:41:59PM +0000, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 12 September 2013, Greg Kroah-Hartman wrote:
> > On Thu, Sep 12, 2013 at 11:22:40AM -0700, Greg Kroah-Hartman wrote:
> > > On Thu, Sep 12, 2013 at 11:18:40AM -0700, Linus Torvalds wrote:
> > > > On Thu, Sep 12, 2013 at 11:17 AM, Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > > Your script may be a bit buggered...
> > > > 
> > > > Or maybe I should take that as a sign that 3.11 is doing really well?
> > > > 
> > > > I'll be optimistic.
> > > 
> > > Hm, something went wrong here, let me track it down...
> > 
> > Ok, that was my fault, was working off of a 'master' branch in a repo
> > that expected it to be on the linux-3.11.y branch.  Here's the real
> > pseudo-shortlog below.
> […]
> 
> This unfortunately affects the linked patch files as well, which are as
> empty as the shortlog (compressed zero byte files); the sha256sum are 
> correct:
> 
> $ wget -qO- kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.1-rc1.gz | gzip -d
> $
> 
> $ wget -qO- kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.1-rc1.bz2 | bzip2 -d
> $
> 
> $ wget -qO- kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.1-rc1.xz | xz -d
> xz: (stdin): File format not recognized

Ah, good catch, I've copied up the patch properly and it should mirror
out soon.

thanks,

greg k-h
