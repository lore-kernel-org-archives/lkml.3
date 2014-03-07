Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaCGVXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:23:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43550 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaCGVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:23:44 -0500
Date: Fri, 07 Mar 2014 16:23:41 -0500 (EST)
Message-Id: <20140307.162341.1600860024275495539.davem@davemloft.net>
To: joe@perches.com
Cc: alistair@popple.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, akpm@linux-foundation.org,
        error27@gmail.com, josh@joshtriplett.org, randy.dunlap@oracle.com
Subject: Re: rfc: checkpatch logical line continuations
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394226164.16156.96.camel@joe-AO722>
References: <1394077948-8395-3-git-send-email-alistair@popple.id.au>
	<20140307.154142.488351276799532264.davem@davemloft.net>
	<1394226164.16156.96.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 13:23:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 07 Mar 2014 13:02:44 -0800

> Right now, checkpatch emits a --strict only warning on "&&" or "||"
> at the beginning of line but that could be changed to any "$Operators"
> 
> our $Arithmetic = qr{\+|-|\*|\/|%};
> our $Operators	= qr{
> 			<=|>=|==|!=|
> 			=>|->|<<|>>|<|>|!|~|
> 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
> 		  }x;
> 
> The ones that likely have a too high false positive rates
> are the negation "!" and bitwise "~".

Unary operators at the beginning of a line are perfectly fine,
it's the other ones that are the problem.
