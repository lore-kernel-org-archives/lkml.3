Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaHLCwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:52:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaHLCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:52:12 -0400
Date: Tue, 12 Aug 2014 10:51:32 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Scott <Dave.Scott@eu.citrix.com>, linux-kernel@vger.kernel.org,
        jslaby@suse.cz
Subject: Re: [PATCH] xen_hvc: no reason to write the type key on xenstore
Message-ID: <20140812025132.GG17509@kroah.com>
References: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1408111532020.2293@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408111532020.2293@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 03:32:48PM +0100, Stefano Stabellini wrote:
> CC'ing tty maintainers.

Why?  Is that how you submit a patch to be included to the kernel tree?
(hint, the answer is no, and also you should cc: the linux-serial
list...)

greg k-h
