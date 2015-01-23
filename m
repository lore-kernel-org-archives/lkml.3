Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbbAWKvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:51:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbbAWKuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:50:51 -0500
Date: Fri, 23 Jan 2015 11:50:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Howells <dhowells@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: /proc/keys is not unconditionally available
In-Reply-To: <11415.1421965730@warthog.procyon.org.uk>
Message-ID: <alpine.LNX.2.00.1501231150380.10817@pobox.suse.cz>
References: <alpine.LNX.2.00.1501222142160.10817@pobox.suse.cz> <alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz> <11415.1421965730@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, David Howells wrote:

> > > Documentation/module-signing.txt file is referring to /proc/keys file in 
> > > order to view all keys contained in the kernel's keyring. That file is not 
> > > universally avialble when CONFIG_KEYS is enabled, which is confusing. The 
> > > fact that the option needed for this procfs interface to exist contains 
> > > "_DEBUG_" in its name makes it even more confusing. Document this fact.
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > Noone complained, but it doesn't seem to have made its way to linux-next 
> > either. I am now pushing it out to trivial.git.
> 
> Sorry, I should've dealt with this.  What we actually need to do is make
> /proc/keys unconditional as it's used by libkeyutils.

OK, I am dropping the documentation update. Thanks,

-- 
Jiri Kosina
SUSE Labs
