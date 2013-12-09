Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374Ab3LIKnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:43:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39806 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab3LIKng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:43:36 -0500
Date: Mon, 9 Dec 2013 11:43:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH 2/2] tools/: Move fs.* to lib/api/fs/
Message-ID: <20131209104332.GC31650@pd.tnic>
References: <1386260752-16436-1-git-send-email-bp@alien8.de>
 <1386260752-16436-3-git-send-email-bp@alien8.de>
 <20131209102650.GD1242@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131209102650.GD1242@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 11:26:50AM +0100, Jiri Olsa wrote:
> > @@ -1,8 +1,13 @@
> > +/* TODO merge/factor into debugfs.c */
> 
> I guess now above one should be:
> 
>  TODO merge/factor debugfs object in here
> 
> ;-)

Right, done!

Thanks guys, I'll resend soonish.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
