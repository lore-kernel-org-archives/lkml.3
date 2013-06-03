Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3FCUMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:12:21 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63444 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:12:20 -0400
Date: Mon, 3 Jun 2013 22:12:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/8] vtime: Use consistent clocks among nohz accounting
Message-ID: <20130603201214.GD31107@somewhere>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
 <1369065716-22801-3-git-send-email-fweisbec@gmail.com>
 <51AC6625.3080000@message-id.invalid.com>
 <20130603194806.GC31107@somewhere>
 <51ACF3C9.2090701@message-id.googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51ACF3C9.2090701@message-id.googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 09:51:37PM +0200, Stefan Seyfried wrote:
> Am 03.06.2013 21:48, schrieb Frederic Weisbecker:
> > On Mon, Jun 03, 2013 at 11:47:17AM +0200, Stefan Seyfried wrote:
> >> FWIW:
> >> Tested-by: Stefan Seyfried <seife+dev@b1-systems.com>
> >>
> >> This patch fixes the 0% CPU issue on openSUSE Factory kernels for me.
> > 
> > Thanks! The patch has been committed already so I can't add your Tested-by:
> > but feedbacks on testing are always appeciated.
> 
> But it did not end up in Linus' tree yet. That would be more important
> for me than the credits in the commit message :-)

It will soon :)

> 
> Thanks,
> 
> 	Stefan
> -- 
> Stefan Seyfried
> Linux Consultant & Developer -- GPG Key: 0x731B665B
> 
> B1 Systems GmbH
> Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
> GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
