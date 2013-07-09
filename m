Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3GIC3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 22:29:09 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:52575 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3GIC3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 22:29:06 -0400
Date: Mon, 08 Jul 2013 21:29:00 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [GIT] Networking
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130707.132133.1335860703202153192.davem@davemloft.net>
	<CA+55aFzgBXwye=ebPmEDN_6yqdKA6ZaD9hSUzbFjSacC_v3y5g@mail.gmail.com>
In-Reply-To: <CA+55aFzgBXwye=ebPmEDN_6yqdKA6ZaD9hSUzbFjSacC_v3y5g@mail.gmail.com>
	(from torvalds@linux-foundation.org on Sun Jul  7 16:27:54 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373336940.27613.24@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2013 04:27:54 PM, Linus Torvalds wrote:
> And dammit, I'd expect the VFS people to be
> cc'd on changes to the VFS layer functions. I wasn't, Al wasn't.

Um, does that mean I should have cc'd you on the initmpfs patch series
back before the merge window opened?

   http://lkml.indiana.edu/hypermail/linux/kernel/1306.3/04204.html

(I cc'd the scripts/get_maintainer.pl list, but only one person replied
this time around. I got more on the initial RFC submission back in
https://lwn.net/Articles/545740/)

Rob