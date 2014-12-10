Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaLJBGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:06:43 -0500
Received: from ns.horizon.com ([71.41.210.147]:32178 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752366AbaLJBGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:06:42 -0500
Date: 9 Dec 2014 20:06:38 -0500
Message-ID: <20141210010638.11895.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: tglx@linutronix.de
Subject: Re: [GIT PULL] arch/nios2 for v3.19
Cc: arnd@arndb.de, lftan@altera.com, linux@horizon.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> It's a bit sad that all the reviewed/acked-by information which has
> been sent throughout the review process is completely lost.

Well, in the case here where the ack comes in after the pull request,
obviously only the merger (Linus) can add it, but for older ones,
it seems like an obvious git feature request to have comments in the
annotated tag automatically copied to the merge commit message draft.

That way, the subsystem maintainer could write a branch summary, like
the [PATCH 0/n] summaries that are popular, and have it automatically
included in the history.

That just seems a more sensible place to put things than the pull
request e-mail.

(Preserving the signed annotated tag object itself is another
intriguing possibility, but not only is it a huge format change
to create a way for a commit to point to a tag, but I also don't
see how to avoid tag name collision problems.)
