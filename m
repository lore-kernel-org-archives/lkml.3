Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbaDJTEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:04:49 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:6007 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaDJTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:04:46 -0400
Message-ID: <1397156681.2053.4.camel@j-VirtualBox>
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 12:04:41 -0700
In-Reply-To: <20140410172851.GF26782@laptop.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
	 <20140409121940.GA12890@node.dhcp.inet.fi>
	 <1397108579.2586.15.camel@j-VirtualBox>
	 <20140410091824.GL10526@twins.programming.kicks-ass.net>
	 <1397150084.3032.4.camel@j-VirtualBox>
	 <20140410172851.GF26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 19:28 +0200, Peter Zijlstra wrote:
> On Thu, Apr 10, 2014 at 10:14:44AM -0700, Jason Low wrote:
> > So one thing I noticed that is different in the current code is that in
> > debug_mutex_unlock(), there is is a possibility that it does not unlock
> > the mutex (when !debug_locks). May be interesting to try out this
> > patch too:
> 
> Yeah; look at a few mails down :-) I spotted it too when I woke up.

Ah, I've received those mails in my inbox just now. :)

