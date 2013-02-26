Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab3BZRwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:52:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39702 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3BZRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:52:04 -0500
Date: Tue, 26 Feb 2013 12:52:02 -0500 (EST)
Message-Id: <20130226.125202.1374826902005255618.davem@davemloft.net>
To: andre@tomt.net
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/58] 3.7.10-stable review
From: David Miller <davem@davemloft.net>
In-Reply-To: <512CF2C9.5060309@tomt.net>
References: <20130225221636.018756060@linuxfoundation.org>
	<512CF2C9.5060309@tomt.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Feb 2013 09:52:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Tomt <andre@tomt.net>
Date: Tue, 26 Feb 2013 18:37:13 +0100

> Hi Greg, David.
> 
> The patches for the sock_diag privilege escalation issue in 3.3-3.8
> seems to be missing. Would be good to get those out the way before 3.7
> is retired.
> 
> http://comments.gmane.org/gmane.linux.network/260062
> 
> Hmm. Seems to be missing stable tag and CC. David?

People have already been poked about this, it will go in, but I can't
until Linus takes my pull request from yesterday and the changes
actually make it into his tree first.
