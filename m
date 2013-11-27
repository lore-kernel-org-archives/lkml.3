Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3K0PnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:43:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45392 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab3K0PnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:43:03 -0500
Date: Wed, 27 Nov 2013 16:42:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131127154255.GJ32267@pd.tnic>
References: <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122135034.GA20146@nazgul.tnic>
 <20131122153910.GA15636@gmail.com>
 <20131122155425.GA15836@gmail.com>
 <20131123131243.GB24148@pd.tnic>
 <20131126180333.GC9958@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131126180333.GC9958@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 07:03:33PM +0100, Ingo Molnar wrote:
> Not necessarily, if the number goes up - obviously then we'd also want
> to add some second directory structure to organize them into broad
> categories or so.

Right, topic libraries. That is starting to make more sense. :)

> Unnecessarily longer build time.

Ok.

> If a tool uses just a handful of these (hopefully quickly increasing
> number of) facilities then it should not be burdened by building it
> all.

Ok. This still hints at topic libraries as being the best alternative.

> The preprocessor does nothing with the .a - eliminating extra stuff
> from the .a is a link time step, and that means the whole .a will be
> built first ...

Ok, this is an argument I can get on board with.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
