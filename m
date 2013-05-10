Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3EJLE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:04:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45824 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab3EJLE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:04:27 -0400
Date: Fri, 10 May 2013 13:10:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        namhyung@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 8/9] liblockdep: Add the 'lockdep' user-space utility
Message-ID: <20130510111027.GB23014@pd.tnic>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-9-git-send-email-sasha.levin@oracle.com>
 <20130510091912.GD3039@dyad.programming.kicks-ass.net>
 <20130510093557.GA16429@gmail.com>
 <20130510104134.GE31235@dyad.programming.kicks-ass.net>
 <20130510110046.GB18805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510110046.GB18805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 01:00:46PM +0200, Ingo Molnar wrote:
> The way I do it is that I have two files named 'ack' and 'sob', with
> my Acked-by and Signed-off-by lines in them, so I can read them into
> whatever editing context I need them, without typing out the full
> thing.

You must have a 'nack' one too :-) Or you rather relish typing this
everytime by hand, with gusto?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
