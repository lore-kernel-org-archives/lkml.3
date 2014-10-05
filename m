Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaJEX7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:59:37 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57841 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJEX7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:59:35 -0400
Message-ID: <1412553572.11091.29.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Why do we still have 32 bit counters? Interrupt counters
 overflow within 50 days
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2014 16:59:32 -0700
In-Reply-To: <alpine.DEB.2.11.1410052331420.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
	 <alpine.DEB.2.11.1410031231420.4383@nanos>
	 <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
	 <20141003120345.GA6652@localhost.localdomain>
	 <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
	 <alpine.DEB.2.11.1410052331420.4383@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-05 at 23:49 +0200, Thomas Gleixner wrote:

> Whats so hard about 64bit counters on 32bit machines?

Not hard, but not trivial either.

> 
> > expensive to handle in particular because these counters are used in
> > performance critical hotpaths.
> 
> The expensive overhead is a single "adcl" instruction.
> 

Assuming a reader do not care of reading garbage yes, while carry is not
yet propagated.



