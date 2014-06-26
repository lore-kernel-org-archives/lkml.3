Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaFZCNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:13:11 -0400
Received: from imap.thunk.org ([74.207.234.97]:58670 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbaFZCNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:13:09 -0400
Date: Wed, 25 Jun 2014 22:13:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: T Makphaibulchoke <tmac@hp.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/mbcache.c: replacing __builtin_log2() with ilog2()
Message-ID: <20140626021300.GC6826@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	T Makphaibulchoke <tmac@hp.com>, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1401471304-37479-1-git-send-email-tmac@hp.com>
 <alpine.LFD.2.11.1406250017571.23403@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406250017571.23403@eddie.linux-mips.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 12:24:49AM +0100, Maciej W. Rozycki wrote:
> On Fri, 30 May 2014, T Makphaibulchoke wrote:
> 
> > Fixing compiler error with some gcc version(s) that do not
> > support __builtin_log2().  Replacing __builtin_log2() with
> > ilog2().
> > 
> > Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
> 
> Reviewed-by: Maciej W. Rozycki <macro@linux-mips.org>

Thanks, applied.

					- Ted
