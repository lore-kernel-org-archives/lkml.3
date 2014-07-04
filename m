Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbaGDRhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:37:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbaGDRhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:37:46 -0400
Date: Fri, 4 Jul 2014 10:37:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Thomas =?iso-8859-1?Q?Sch=F6bel-Theuer?= 
	<thomas@schoebel-theuer.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Selling Points for MARS Light
Message-ID: <20140704173719.GC25992@kroah.com>
References: <53B6897F.6020802@schoebel-theuer.de>
 <CAFLxGvynFuCh0puda06kTH1P3i=701dQO-+opjLnQrd2KqUTHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvynFuCh0puda06kTH1P3i=701dQO-+opjLnQrd2KqUTHA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 03:04:07PM +0200, Richard Weinberger wrote:
> On Fri, Jul 4, 2014 at 1:01 PM, Thomas Schöbel-Theuer
> <thomas@schoebel-theuer.de> wrote:
> > Hi together,
> >
> > since not all people have attended my presentations on MARS Light, and
> > since probably not all are willing to click at links such as to the
> > presentation slides
> > https://github.com/schoebel/mars/blob/master/docu/MARS_LinuxTag2014.pdf?raw=true
> > , I will try to explain something which goes beyond the presentations,
> > but nevertheless I don't want to repeat too much from the slides.
> >
> > So the following is hopefully also interesting for people who attended
> > the presentations.
> >
> > My main selling point:
> >
> > To my knowledge, MARS Light is the only enterprise-grade opensource
> > solution constructed for mass replication of whole datacenters
> > (thousands to tenthousands of instances) over _long_ _distances_, aka
> > _geo-redundancy_.
> 
> I think hch meant not a high level marketing-drone -ready design document
> by "explain and sell your design".
> We are interested in the real low level design ideas.
> i.e. Why do you need all syscalls exported?

Exactly, normally we don't care about any high-level things, I want to
know why you think you have to call remove within a kernel module when
no one else does that.

Also, I doubt you handle the namespace issue properly, but given that it
is impossible to review the 50+ patches as sent, it might be correct, or
might not, I don't know...

greg k-h
