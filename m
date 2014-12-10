Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaLJByb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:54:31 -0500
Received: from imap.thunk.org ([74.207.234.97]:48426 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbaLJByX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:54:23 -0500
Date: Tue, 9 Dec 2014 20:54:21 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: tglx@linutronix.de, arnd@arndb.de, lftan@altera.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.horizon.com
Subject: Re: [GIT PULL] arch/nios2 for v3.19
Message-ID: <20141210015421.GB3370@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, tglx@linutronix.de,
	arnd@arndb.de, lftan@altera.com, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.horizon.com
References: <20141210010638.11895.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210010638.11895.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 08:06:38PM -0500, George Spelvin wrote:
> 
> (Preserving the signed annotated tag object itself is another
> intriguing possibility, but not only is it a huge format change
> to create a way for a commit to point to a tag, but I also don't
> see how to avoid tag name collision problems.)

Actually, git already preserves the signed annotated tag.  That's the
only way git show --show-signature can verify the tag's gpg signature.

You can see original signed annotated tag via a command like this:

git cat-file -p 18b34d9a7a085ba8f9cafa6a0d002e2cbac87c1f

						- Ted
