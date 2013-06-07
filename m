Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3FGQAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:00:25 -0400
Received: from 1wt.eu ([62.212.114.60]:36200 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab3FGQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:00:23 -0400
Date: Fri, 7 Jun 2013 18:00:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 102/184] Bluetooth: fix possible info leak in
Message-ID: <20130607160015.GN19006@1wt.eu>
References: <20130604172134.542955449@1wt.eu> <1370586900.4149.0.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370586900.4149.0.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:35:00AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  bt_sock_recvmsg()
> > 
> > From: Mathias Krause <minipli@googlemail.com>
> 
> commit 4683f42fde3977bdb4e8a09622788cc8b5313778 upstream.

Added, thank you.

Willy

