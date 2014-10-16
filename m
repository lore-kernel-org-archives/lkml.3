Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaJPPrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:47:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60585 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaJPPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:47:40 -0400
Date: Thu, 16 Oct 2014 17:47:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 1/5] x86: Clean up cr4 manipulation
Message-ID: <20141016154743.GC30314@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <724658a527c0572dde1a400a5e90b85f45421201.1413323611.git.luto@amacapital.net>
 <20141016081633.GG7369@worktop.fdxtended.com>
 <20141016111858.GB25025@nazgul.tnic>
 <20141016112910.GC25025@nazgul.tnic>
 <CALCETrV1-26=NVQu7iSv9PS1OBM7r-O9YGf0fc2r0CQv-ZN95Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrV1-26=NVQu7iSv9PS1OBM7r-O9YGf0fc2r0CQv-ZN95Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 08:32:57AM -0700, Andy Lutomirski wrote:
> That's in patch 2.  I can move it here, though.

Right, saw it after sending. And nah, don't bother.

-- 
Regards/Gruss,
    Boris.
--
