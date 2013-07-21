Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3GUPGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:06:39 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50632 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3GUPGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:06:36 -0400
Date: Sat, 20 Jul 2013 23:06:16 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Willy Tarreau <w@1wt.eu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1373916476.2748.69.camel@dabdike>
	<1373917517.17876.193.camel@gandalf.local.home>
	<20130715195505.GE10157@1wt.eu>
	<1373921779.17876.200.camel@gandalf.local.home>
	<1373922593.2062.36.camel@joe-AO722>
In-Reply-To: <1373922593.2062.36.camel@joe-AO722> (from joe@perches.com on
	Mon Jul 15 16:09:53 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374379576.3719.24@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 04:09:53 PM, Joe Perches wrote:
> On Mon, 2013-07-15 at 16:56 -0400, Steven Rostedt wrote:
> > It may not be efficient for maintainers, but as maintainers we  
> should
> > spend a bit more time on stable releases.
> 
> The MAINTAINERS file specifies a difference between a
> section that's Maintained vs Supported.
> 
> Do please remember there's a difference between a maintainer
> and someone that's paid to support a particular thing.
> 
> My feeling is if you're a maintainer you can just say
> "use the current version" and not spend even a moments
> effort or thought on backports.
> 
> When you're getting paid however, different issues...

Then you get to say "you're not a customer of my company, I don't have  
to listen to you at all". (See Renesas with sh4 circa 2010.)

Rob