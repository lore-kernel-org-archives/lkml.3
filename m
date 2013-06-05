Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3FEOT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:19:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43617 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3FEOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:19:23 -0400
Date: Wed, 5 Jun 2013 10:19:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: Please backport bee980d9e9642e96351fa3ca9077b853ecf62f57
 (xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.) to
 earlier kernels v3.8...and so on
Message-ID: <20130605141916.GA4576@phenom.dumpdata.com>
References: <20130603120232.GA6893@phenom.dumpdata.com>
 <20130605041411.GA26051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605041411.GA26051@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 09:14:11PM -0700, Greg KH wrote:
> On Mon, Jun 03, 2013 at 08:02:32AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Greg,
> > 
> > I hadn't (by mistake) put the CC: stable@vger.kernel.org on said patch
> > (Which is in the Linux kernel).
> > 
> > If possible please back-port said patch to the existing stable trees.
> > Attached is a version that applies to some of the earlier trees easily.
> 
> Now applied to 3.0 and 3.4-stable trees.

Much appreciated!
> 
> greg k-h
