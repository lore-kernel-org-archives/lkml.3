Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaFPKwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:52:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaFPKwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:52:13 -0400
From: Andreas Schwab <schwab@suse.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
	<20140616102927.GA2994@mwanda>
X-Yow: YOW!!
Date: Mon, 16 Jun 2014 12:52:10 +0200
In-Reply-To: <20140616102927.GA2994@mwanda> (Dan Carpenter's message of "Mon,
	16 Jun 2014 13:29:27 +0300")
Message-ID: <mvmsin51605.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Adding "--param allow-store-data-races=0" to the GCC options for the
> kernel breaks C=1 because Sparse isn't expecting a GCC option with that
> format.

Please try --param=allow-store-data-races=0 instead.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
