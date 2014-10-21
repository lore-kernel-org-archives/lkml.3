Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaJUGF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:05:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42244 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaJUGFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:05:55 -0400
Date: Tue, 21 Oct 2014 08:05:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 3/5] x86: Add a comment clarifying LDT context switching
Message-ID: <20141021060531.GB4420@pd.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <93ffc13d9e829f3ded9776fec62385bccb7439e1.1413323612.git.luto@amacapital.net>
 <20141016154914.GD30314@nazgul.tnic>
 <CALCETrVmS+ZNj+iXNTy5zC8araMH=x=jUBNDMUNPDJwu0huMMQ@mail.gmail.com>
 <20141021054118.GA4420@pd.tnic>
 <CALCETrV-2h1H-c7GTzNXvjmT6yzmGzzP6R6hce5QhZbCEi0oKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrV-2h1H-c7GTzNXvjmT6yzmGzzP6R6hce5QhZbCEi0oKw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:44:18PM -0700, Andy Lutomirski wrote:
> You're exactly correct, or at least you seem to understand it the way I do :)

Ok, cool.

Now, if I had more time, I'd take a guest and add some debugging
code to see when exactly that happens and how prev->context.ldt and
next->context.ldt look... Maybe later. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
