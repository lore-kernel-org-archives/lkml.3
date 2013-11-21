Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3KUTA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:00:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35650 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab3KUTA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:00:27 -0500
Date: Thu, 21 Nov 2013 20:00:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121190019.GP26009@pd.tnic>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121173714.GD24806@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:37:14PM -0300, Arnaldo Carvalho de Melo wrote:
> But "libkapi" seems the wrong name for a library with those utilities :-\

Yeah, I know.

However, since we're keeping the library internal, we can take that name
for now and later, when we expose it outside, we can decide what to call
it or to split it.

I have the feeling we will come up with a proper name when we least
expect it. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
