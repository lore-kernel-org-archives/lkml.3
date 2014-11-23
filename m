Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaKWVjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 16:39:02 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46447 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaKWVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:39:00 -0500
Date: Sun, 23 Nov 2014 22:38:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Mason <clm@fb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: New crashes walking proc with Saturday's git
Message-ID: <20141123213858.GA17836@pd.tnic>
References: <20141123010239.GA12691@ret.masoncoding.com>
 <1416758187.24312.12@mail.thefacebook.com>
 <20141123161120.GB7070@pd.tnic>
 <1416759411.24312.13@mail.thefacebook.com>
 <20141123163258.GB6436@pd.tnic>
 <1416761342.24312.15@mail.thefacebook.com>
 <alpine.DEB.2.11.1411232141590.6439@nanos>
 <1416777079.1732.0@mail.thefacebook.com>
 <1416778193.3019.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416778193.3019.0@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 04:29:53PM -0500, Chris Mason wrote:
> 11 minutes later and it's still alive. I'll keep an eye on it and yell
> if it falls over.

Ditto. Box here suspends and resumes fine even while the fork bomb is
running. I'll watch it the next days just in case though.

Reported-and-tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
