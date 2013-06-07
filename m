Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3FGPyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:54:01 -0400
Received: from 1wt.eu ([62.212.114.60]:36183 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3FGPx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:53:59 -0400
Date: Fri, 7 Jun 2013 17:53:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 184/184] tipc: fix info leaks via msg_name in
Message-ID: <20130607155352.GK19006@1wt.eu>
References: <20130604172137.930866926@1wt.eu> <1370586167.3693.0.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370586167.3693.0.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:22:47AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  recv_msg/recv_stream
> > 
> > From: Mathias Krause <minipli@googlemail.com>
> 
> commit 60085c3d009b0df252547adb336d1ccca5ce52ec upstream.

Thank you Ben
Willy

