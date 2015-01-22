Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbbAVW3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbbAVW3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:29:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1501222142160.10817@pobox.suse.cz>
References: <alpine.LNX.2.00.1501222142160.10817@pobox.suse.cz> <alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: /proc/keys is not unconditionally available
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11414.1421965730.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 22 Jan 2015 22:28:50 +0000
Message-ID: <11415.1421965730@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> wrote:

> > Documentation/module-signing.txt file is referring to /proc/keys file in 
> > order to view all keys contained in the kernel's keyring. That file is not 
> > universally avialble when CONFIG_KEYS is enabled, which is confusing. The 
> > fact that the option needed for this procfs interface to exist contains 
> > "_DEBUG_" in its name makes it even more confusing. Document this fact.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Noone complained, but it doesn't seem to have made its way to linux-next 
> either. I am now pushing it out to trivial.git.

Sorry, I should've dealt with this.  What we actually need to do is make
/proc/keys unconditional as it's used by libkeyutils.

David
