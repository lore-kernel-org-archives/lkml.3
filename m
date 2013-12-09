Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab3LIKmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:42:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39772 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3LIKmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:42:21 -0500
Date: Mon, 9 Dec 2013 11:42:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
Message-ID: <20131209104217.GB31650@pd.tnic>
References: <1386260752-16436-1-git-send-email-bp@alien8.de>
 <1386260752-16436-2-git-send-email-bp@alien8.de>
 <20131209102245.GC1242@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131209102245.GC1242@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 11:22:45AM +0100, Jiri Olsa wrote:
> > -$(LIBLK)-clean:
> > +$(LIBAPIKFS)-clean:
> >  ifeq ($(subdir),)
> > -	$(call QUIET_CLEAN, liblk)
> > -	@$(MAKE) -C $(LK_DIR) O=$(OUTPUT) clean >/dev/null
> > +	$(call QUIET_CLEAN, LIBAPIKFS)
> 
> do we want 'LIBAPIKFS' in lowercase here?

We do!

... aaand

	[what was the vim shortcut... /me looks, finds it, executes it]

done.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
