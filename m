Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaGVOZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:25:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaGVOY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:24:59 -0400
Date: Tue, 22 Jul 2014 16:24:56 +0200
From: Borislav Petkov <bp@suse.de>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, kay@vrfy.org, pmladek@suse.cz,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] printk: more log flag simplification
Message-ID: <20140722142456.GB10670@pd.tnic>
References: <1406037717-9670-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406037717-9670-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:01:55AM -0500, Alex Elder wrote:
> This series eliminates the LOG_CONT entirely from the printk/log code.
> It builds on another series, posted earlier today:
>     http://www.spinics.net/lists/kernel/msg1791665.html
> This series was originally longer, but in review I was reminded
> that some of the simplifications I had done were not valid.
> 
> The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
> are inverses, and uses LOG_NEWLINE (or its negation) anywhere
> LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
> it's eliminated.
> 
> The second patch improves some comments and makes a few small
> code cleanups, now that it's gone through this transformation.

This is getting ridiculous - you've been spamming me with printk patches
like crazy every day! I told you to wait a bit with a resend until
people have had a chance to review them, but you don't seem to care.

Would you please remove me from your CC list?

Thank you.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
