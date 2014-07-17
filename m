Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbaGQPir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:38:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48863 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934305AbaGQPin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:38:43 -0400
Date: Thu, 17 Jul 2014 17:38:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, apw@canonical.com, joe@perches.com,
        tytso@mit.edu, dwalter@google.com, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140717153838.GC22791@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405611268-12463-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:34:28PM +0200, Richard Weinberger wrote:
> checkpatch.pl is a nice tool to find issues in patches.
> Sadly this tool gets more and more  abused by various people to create
> style cleanups for source files within the kernel.
> In order to deal with that bad habit let's remove the --file option
> and bring checkpatch.pl back to its original purpose.
> 
> Suggested-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Very good idea:

Acked-by: Borislav Petkov <bp@suse.de>

You could also make it do:

	if ($file) {
		print STDERR "Go find real bugs in the kernel instead!\n";
		exit(-1);
	}

if someone supplies --file on the cmdline.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
