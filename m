Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3FTP7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:59:53 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38860 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab3FTP7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:59:52 -0400
Date: Thu, 20 Jun 2013 17:59:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/7] hw_breakpoint: fixes/cleanups
Message-ID: <20130620155948.GA20797@gmail.com>
References: <20130620154947.GA6301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620154947.GA6301@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo,
> 
> 1/7 and 2/7 fix the WARN_ONCE("Can't find any breakpoint slot") problem
> reported by Vince. The problem is minor but the patches look simple, so
> perhaps this is 3.10 material. And I added -stable.
> 
> Other changes are cleanups/simplifications.
> 
> The patches are the same, I only added the acks from Frederic.
> 
> Oleg.
> 
>  kernel/events/hw_breakpoint.c |  188 +++++++++++++++++------------------------
>  1 files changed, 79 insertions(+), 109 deletions(-)

Applied, thanks a lot Oleg!

	Ingo
