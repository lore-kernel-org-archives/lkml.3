Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaFYUya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:54:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbaFYUy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:54:29 -0400
Date: Wed, 25 Jun 2014 22:54:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Sasha Pachev <sasha@asksasha.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Invalid date in a commit
In-Reply-To: <CALtpbwjVVyFNOOYHcZw8+WHENoDZKzeZ80MCdNpROzX2mXa0Eg@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1406252253510.6551@twin.jikos.cz>
References: <CALtpbwjVVyFNOOYHcZw8+WHENoDZKzeZ80MCdNpROzX2mXa0Eg@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Sasha Pachev wrote:

> I am looking at
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=12ca45fea91cfbb09df828bea958b47348caee6d
> 
> author Daniel Vetter <daniel.vetter@ffwll.ch>2037-04-25 08:08:26 (GMT)

That's very close to the magical 2038! :-)

> committer Eric Anholt <eric@anholt.net>2009-11-30 17:44:23 (GMT)
> 
> Looks like there was a problem with the clock for Daniel. Should that be fixed?

It's not possible to fix it without rebase.

-- 
Jiri Kosina
SUSE Labs

