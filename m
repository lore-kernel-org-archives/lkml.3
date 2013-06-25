Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3FYVRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:17:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59949 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3FYVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:17:17 -0400
Date: Tue, 25 Jun 2013 23:17:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130625211713.GA18796@laptop.programming.kicks-ass.net>
References: <51CA0622.8010105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CA0622.8010105@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:05:38PM -0600, David Ahern wrote:
> Peter/Ingo:
> 
> I can reliably cause a deadlock in the scheduler by enabling the HRTICK
> feature. I first hit the problem with 2.6.27 but have been able to reproduce
> it with newer kernels. I have not tried top of Linus' tree, so perhaps this
> has been fixed in 3.10. 

Yeah, I know.. its been on the todo list forever but its never been
important. Its disabled by default and all sched debug features are for
those brave enough to keep the pieces ;-)
