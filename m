Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbbATQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:09:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbbATQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:09:27 -0500
Date: Tue, 20 Jan 2015 17:09:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Miroslav Benes <mbenes@suse.cz>, sjenning@redhat.com, vojtech@suse.cz,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmladek@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH] livepatch: change ARCH_HAVE_LIVE_PATCHING to
 HAVE_LIVE_PATCHING
In-Reply-To: <20150120124926.GB15916@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1501201502440.10817@pobox.suse.cz>
References: <1421754575-30071-1-git-send-email-mbenes@suse.cz> <20150120124926.GB15916@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Josh Poimboeuf wrote:

> On Tue, Jan 20, 2015 at 12:49:35PM +0100, Miroslav Benes wrote:
> > Change ARCH_HAVE_LIVE_PATCHING to HAVE_LIVE_PATCHING in Kconfigs. HAVE_
> > bools are prevalent there and we should go with the flow.
> > 
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> 
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

Applied and pushed out.

-- 
Jiri Kosina
SUSE Labs
