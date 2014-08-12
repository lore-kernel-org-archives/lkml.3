Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaHLJIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:08:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:47642 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbaHLJIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:08:15 -0400
X-IronPort-AV: E=Sophos;i="5.01,847,1400025600"; 
   d="scan'208";a="160863998"
Date: Tue, 12 Aug 2014 10:06:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Greg KH <gregkh@linuxfoundation.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Scott <Dave.Scott@eu.citrix.com>, <linux-kernel@vger.kernel.org>,
        <jslaby@suse.cz>
Subject: Re: [PATCH] xen_hvc: no reason to write the type key on xenstore
In-Reply-To: <20140812025132.GG17509@kroah.com>
Message-ID: <alpine.DEB.2.02.1408121005470.2293@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com> <alpine.DEB.2.02.1408111532020.2293@kaball.uk.xensource.com> <20140812025132.GG17509@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Greg KH wrote:
> On Mon, Aug 11, 2014 at 03:32:48PM +0100, Stefano Stabellini wrote:
> > CC'ing tty maintainers.
> 
> Why?  Is that how you submit a patch to be included to the kernel tree?
> (hint, the answer is no, and also you should cc: the linux-serial
> list...)

Sorry, I resent it.
