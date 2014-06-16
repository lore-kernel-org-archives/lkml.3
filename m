Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaFPLUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:20:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbaFPLUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:20:51 -0400
Date: Mon, 16 Jun 2014 13:20:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andreas Schwab <schwab@suse.de>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
In-Reply-To: <mvmsin51605.fsf@hawking.suse.de>
Message-ID: <alpine.LNX.2.00.1406161320180.1321@pobox.suse.cz>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz> <20140616102927.GA2994@mwanda> <mvmsin51605.fsf@hawking.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Andreas Schwab wrote:

> > Adding "--param allow-store-data-races=0" to the GCC options for the
> > kernel breaks C=1 because Sparse isn't expecting a GCC option with that
> > format.
> 
> Please try --param=allow-store-data-races=0 instead.

How reliable is this format across GCC versions? GCC manpage doesn't seem 
to list it as a valid alternative.

-- 
Jiri Kosina
SUSE Labs
