Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab3FEENo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:13:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3FEENl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:13:41 -0400
Date: Tue, 4 Jun 2013 21:14:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: Please backport bee980d9e9642e96351fa3ca9077b853ecf62f57
 (xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.) to
 earlier kernels v3.8...and so on
Message-ID: <20130605041411.GA26051@kroah.com>
References: <20130603120232.GA6893@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603120232.GA6893@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 08:02:32AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> I hadn't (by mistake) put the CC: stable@vger.kernel.org on said patch
> (Which is in the Linux kernel).
> 
> If possible please back-port said patch to the existing stable trees.
> Attached is a version that applies to some of the earlier trees easily.

Now applied to 3.0 and 3.4-stable trees.

greg k-h
