Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaFFN5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:57:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaFFN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:57:02 -0400
Date: Fri, 6 Jun 2014 06:56:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, felipe.franciosi@citrix.com,
        roger.pau@citrix.com, jerry.snitselaar@oracle.com, axboe@kernel.dk,
        vkuznets@redhat.com
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
Message-ID: <20140606135657.GB11781@kroah.com>
References: <20140514191122.GA7659@phenom.dumpdata.com>
 <20140604054848.GA20895@kroah.com>
 <53919C2B.6080606@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53919C2B.6080606@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 12:47:07PM +0200, Jiri Slaby wrote:
> On 06/04/2014 07:48 AM, Greg KH wrote:
> > On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
> >> Hey Greg
> >>
> >> This email is in regards to backporting two patches to stable that
> >> fall under the 'performance' rule:
> >>
> >>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
> >>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
> > 
> > Now queued up, thanks.
> 
> AFAIU, they introduce a performance regression.

That "regression" is also in mainline, right?  As Konrad doesn't seem to
think it matters, I'm deferring to the maintainer here.

thanks,

greg k-h
