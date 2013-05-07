Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3EGNt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:49:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59730 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab3EGNt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:49:57 -0400
Date: Tue, 7 May 2013 15:50:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, setup: Removed spaces, trailing character and
 suspect code indent warnings and errors in a20.c This is a patch to the
 a20.c file that fixes following warnings/errors found by the checkpatch.pl
 tool i)  WARNING: please, no spaces at the start of a line ii) WARNING:
 suspect code indent for conditional statements iii) ERROR: trailing
 whitespace
Message-ID: <20130507135008.GA7678@pd.tnic>
References: <1367932822-31980-1-git-send-email-syed.salman.mansoor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1367932822-31980-1-git-send-email-syed.salman.mansoor@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 06:20:22PM +0500, Syed Salman Mansoor wrote:
> Signed-off-by: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>

No,

this is still wrong:

Subject: [PATCH] x86, setup: Removed spaces, trailing character and suspect code indent warnings and errors in a20.c This is a patch to the a20.c file that
        fixes following warnings/errors found by the checkpatch.pl tool i)  WARNING: please, no spaces at the start of a line ii) WARNING: suspect code
        indent for conditional statements iii) ERROR: trailing whitespace

Don't you think that this Subject line is insanely long but the patch
still doesn't have a commit message?

I can see you're using git so when you do:

git commit -a -s

and the editor opens, simply type in a short name for the patch into the
first line:

"x86, boot: Cleanup A20 code"

or something which hints at what this patch does.

Then, do a newline and on the third line, type in the rest of the
subject above:

> Remove spaces, trailing character and suspect code indent warnings and
> errors in a20.c This is a patch to the a20.c file that fixes following

You don't have to say which file it patches since we can see that from
the diffstat.

> warnings/errors found by the checkpatch.pl tool i) WARNING: please,
> no spaces at the start of a line ii) WARNING: suspect code indent for
> conditional statements iii) ERROR: trailing whitespace

So basically do something like that:

"Fix checkpatch.pl warnings in a20.c:
 i) blabla
 ii) more blabla
 iii) and so on blabla"

Btw, Documentation/SubmittingPatches is a good document to read. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
