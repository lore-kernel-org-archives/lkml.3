Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3KLMnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:43:25 -0500
Received: from imap.thunk.org ([74.207.234.97]:57015 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3KLMnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:43:22 -0500
Date: Mon, 11 Nov 2013 23:24:44 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131112042444.GC30281@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 06:57:25PM -0500, Greg Price wrote:
> 
> I recently read through the random number generator's code.
> This series has fixes for some minor things I spotted.
> 
> Four of the patches touch comments only.  Four simplify code without
> changing its behavior (total diffstat: 35 insertions, 73 deletions),
> and one is a trivial signedness fix.  Two patches change the locking
> and lockless concurrency control in account(), including one bugfix.
> The bug is related to the one Jiri found and fixed in May.

Hi Greg,

My apologies for not being able to get to this patch series before the
patch window opened --- this week has been crazy.  None of the changes
seem to be especially critical, and a number of the patches don't
apply cleanly to the random.git tree (some of the spelling fixes have
already been fixed, for example), which has patches queued up for the
upcoming merge window.  So I'm going to defer applying these patches
for 2.13, and I'd ask you if you'd be willing to rebase these patches
against the random.git tree, so they can be pulled in after the merge
window closes.

Thanks,

					- Ted
