Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbbATTL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:11:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbbATTL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:11:57 -0500
Date: Tue, 20 Jan 2015 20:11:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Jiri Slaby <jslaby@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: support for repatching a function
In-Reply-To: <20150120154736.GA4417@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1501202010290.10817@pobox.suse.cz>
References: <cover.1421767360.git.jpoimboe@redhat.com> <da0d4d3c34441efcd8e830c4c978016581d7f055.1421767360.git.jpoimboe@redhat.com> <54BE7657.2010105@suse.cz> <20150120154736.GA4417@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Josh Poimboeuf wrote:

> Yeah, maybe, depending on the nature of the bug.
> 
> > WARN_ON_RATELIMIT?
> 
> Since this warning should never happen unless there's a code bug, I
> think WARN_ON_ONCE should be sufficient?

Yeah. The stacktrace is likely not to point to the source of the problem 
anyway, so spamming dmesg with it is rather pointless.

I've changed WARN_ON() in ftrace handler to WARN_ON_ONCE() and applied. 
Thanks,

-- 
Jiri Kosina
SUSE Labs
