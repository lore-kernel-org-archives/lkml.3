Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaLWQPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:15:11 -0500
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:44446
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756167AbaLWQPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:15:09 -0500
Date: Tue, 23 Dec 2014 16:11:45 +0000
From: dwalker@fifo99.com
To: Joe Perches <joe@perches.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: add per console loglevel
Message-ID: <20141223161144.GA19144@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
 <20141221194753.49c12693@neptune.home>
 <1419188604.4200.8.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419188604.4200.8.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:03:24AM -0800, Joe Perches wrote:
> On Sun, 2014-12-21 at 19:47 +0100, Bruno Prémont wrote:
> > On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> > > This adds to to the console= command line options allowing the
> > > addition of a per console log level setting.
> > > 
> > > examples,
> > > 
> > > 	console=ttyS0,ll4
> > > 	console=tty0,ll6
> > > 
> > > This can be used on systems which have multiple serial consoles, but
> > > it's desired for logging to be light on one and heavy on another.
> > 
> > Looks useful to me.
> 
> I think this is reasonable to, but for consistency
> with other loglevel uses, I suggest using
> loglevel=<level> instead of ll<d>
> 

I can try it, I didn't do it initially because I didn't want to confuse the parsing of the other
parameters ..

Daniel
