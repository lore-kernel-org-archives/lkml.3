Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab3E0NjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:39:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab3E0NjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:39:15 -0400
Date: Mon, 27 May 2013 15:39:12 +0200
From: Borislav Petkov <bp@suse.de>
To: Rabin Vincent <rabin@rab.in>
Cc: acme@redhat.com, mingo@kernel.org, paulus@samba.org,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] tools lib lk: respect CROSS_COMPILE
Message-ID: <20130527133911.GC4753@pd.tnic>
References: <1368822464-4887-1-git-send-email-rabin@rab.in>
 <CAH+eYFC9F6cLpwYPg7iC2cOsKBJ3P9zEB=VTdA-fFDTPi1bTmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH+eYFC9F6cLpwYPg7iC2cOsKBJ3P9zEB=VTdA-fFDTPi1bTmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 03:28:53PM +0200, Rabin Vincent wrote:
> Ping. Would be nice if this was merged so that perf cross compile is
> no longer broken.

It will be merged, just give acme some more leeway - he's currently
travelling around Europe with spotty internet connection.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
