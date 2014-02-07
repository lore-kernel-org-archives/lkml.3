Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaBGWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:25:57 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:39250 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaBGWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:25:55 -0500
Date: Fri, 7 Feb 2014 16:23:45 -0600
From: David Fries <david@fries.net>
To: zbr@ioremap.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
Message-ID: <20140207222345.GR5452@spacedout.fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
 <9071391471978@web15j.yandex.ru>
 <20140204055131.GI5342@spacedout.fries.net>
 <253061391557725@web20g.yandex.ru>
 <20140207055832.GN5342@spacedout.fries.net>
 <7611391808223@web21g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7611391808223@web21g.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Fri, 07 Feb 2014 16:23:46 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 01:23:43AM +0400, zbr@ioremap.net wrote:
> Hi
> 
> 07.02.2014, 10:00, "David Fries" <david@fries.net>:
> 
> > Here's a patch to implement that.  Is this what you have in mind?
> >
> > From 4ed65d81b0121a8c191a9833d041484e9097198b Mon Sep 17 00:00:00 2001
> > From: David Fries <David@Fries.net>
> > Date: Thu, 6 Feb 2014 23:45:05 -0600
> > Subject: [PATCH] w1: correct cn_msg ack, no change or seq + 1
> >
> > Netlink messages sent from the kernel consists of kernel generated
> > notifications for adds or removes, the error message (also indicates
> > the message has been processed), and the messages that have data to
> > return.  The cn_msg ack is left alone for the first two, and when
> > returning data it is the sequence number + 1.  Modifying the code to
> > the protocol standard.
> >
> > Signed-off-by: David Fries <David@Fries.net>
> 
> Yes, it looks right.
> Can you also check that protocol documentation is correct?

Documentation/connector/connector.txt ?  I found it a little unclear,
I'll see what I can do.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
