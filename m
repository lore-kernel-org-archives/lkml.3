Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab3CVOYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:24:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50567 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933356Ab3CVOYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:24:09 -0400
Date: Fri, 22 Mar 2013 10:24:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Soeren Moch <smoch@web.de>
cc: Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <linux-mm@kvack.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <michael@amarulasolutions.com>
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
In-Reply-To: <514B86A9.60401@web.de>
Message-ID: <Pine.LNX.4.44L0.1303221023310.1294-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Soeren Moch wrote:

> > Hi Alan, Soeren
> >
> > Could you word the description a bit better. If Alan did not get it
> > without a bit of thought, few others are going to understand it
> > without a better explanation.
> >
> > Thanks
> > 	Andrew
> >
> 
> Alan,
> 
> can you come up with a better explanation, please? I think your 
> description how it is supposed to work from here
>     http://marc.info/?l=linux-usb&m=136345559432055&w=2
> is required to understand the problem and the fix.

Okay, I will rewrite your patch description.

Alan Stern

