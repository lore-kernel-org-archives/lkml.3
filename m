Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3ANRlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:41:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:44397 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab3ANRlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:41:08 -0500
Date: Mon, 14 Jan 2013 09:41:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 167/241] SUNRPC: Set alloc_slot for backchannel tcp ops
Message-ID: <20130114174101.GB29411@kroah.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
 <1355407206-17100-168-git-send-email-herton.krzesinski@canonical.com>
 <1355602292.18807.31.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355602292.18807.31.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 08:11:32PM +0000, Ben Hutchings wrote:
> On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Bryan Schumaker <bjschuma@netapp.com>
> > 
> > commit 84e28a307e376f271505af65a7b7e212dd6f61f4 upstream.
> > 
> > f39c1bfb5a03e2d255451bff05be0d7255298fa4 (SUNRPC: Fix a UDP transport
> > regression) introduced the "alloc_slot" function for xprt operations,
> > but never created one for the backchannel operations.  This patch fixes
> > a null pointer dereference when mounting NFS over v4.1.
> [...]
> 
> Greg, you missed this in 3.4.y.  It might need a context fix; I'm
> attaching the version I used for 3.2.y.

No, it's already in 3.4 somehow, but thanks for the patch anyway.

greg k-h
