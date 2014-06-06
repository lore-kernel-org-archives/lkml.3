Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaFFOC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:02:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34158 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaFFOCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:02:25 -0400
Date: Fri, 6 Jun 2014 10:02:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, xen-devel@lists.xenproject.org,
        felipe.franciosi@citrix.com, roger.pau@citrix.com,
        jerry.snitselaar@oracle.com, axboe@kernel.dk, vkuznets@redhat.com
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
Message-ID: <20140606140207.GA9426@localhost.localdomain>
References: <20140514191122.GA7659@phenom.dumpdata.com>
 <20140604054848.GA20895@kroah.com>
 <53919C2B.6080606@suse.cz>
 <20140606135657.GB11781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606135657.GB11781@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 06:56:57AM -0700, Greg KH wrote:
> On Fri, Jun 06, 2014 at 12:47:07PM +0200, Jiri Slaby wrote:
> > On 06/04/2014 07:48 AM, Greg KH wrote:
> > > On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > >> Hey Greg
> > >>
> > >> This email is in regards to backporting two patches to stable that
> > >> fall under the 'performance' rule:
> > >>
> > >>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
> > >>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
> > > 
> > > Now queued up, thanks.
> > 
> > AFAIU, they introduce a performance regression.
> 
> That "regression" is also in mainline, right?  As Konrad doesn't seem to
> think it matters, I'm deferring to the maintainer here.

Hehe.

Greg is correct - the performance regression with tmpfs/ramfs does exist
upstream and once a fix has been established will be dealt with. Right now we
are fousing on the 99% usage models which is solid state, rotational,
and flash (just got one of those) and the two patches outlined above are
needed for the stable trees.

Thank you.

Hopefully I haven't confused the issue here.
> 
> thanks,
> 
> greg k-h
