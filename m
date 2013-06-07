Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3FGFnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:43:13 -0400
Received: from 1wt.eu ([62.212.114.60]:36111 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3FGFnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:43:11 -0400
Date: Fri, 7 Jun 2013 07:43:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 111/184] USB: cdc-wdm: fix buffer overflow
Message-ID: <20130607054306.GJ14633@1wt.eu>
References: <20130604172134.911364563@1wt.eu> <1370581277.4021.74.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370581277.4021.74.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 06:01:17AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Oliver Neukum <oneukum@suse.de>
> > 
> > commit c0f5ecee4e741667b2493c742b60b6218d40b3aa upstream.
> > 
> > The buffer for responses must not overflow.
> > If this would happen, set a flag, drop the data and return
> > an error after user space has read all remaining data.
> > 
> > Signed-off-by: Oliver Neukum <oliver@neukum.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [bwh: Backported to 2.6.32: adjust context]
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Added, thanks.
willy

