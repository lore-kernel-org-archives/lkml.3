Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3FGP5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:57:09 -0400
Received: from 1wt.eu ([62.212.114.60]:36190 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab3FGP5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:57:07 -0400
Date: Fri, 7 Jun 2013 17:52:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Samuel Ortiz <samuel@sortiz.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 183/184] irda: Fix missing msg_namelen update in
Message-ID: <20130607155259.GJ19006@1wt.eu>
References: <20130604172137.889614525@1wt.eu> <1370586022.4021.95.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370586022.4021.95.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:20:22AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  irda_recvmsg_dgram()
> > 
> > From: Mathias Krause <minipli@googlemail.com>
> 
> commit 5ae94c0d2f0bed41d6718be743985d61b7f5c47d upstream.

Added, thanks!
Willy

