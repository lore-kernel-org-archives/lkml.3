Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbbA1Uys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbbA1Uyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150128121207.59254055@lwn.net>
References: <20150128121207.59254055@lwn.net> <alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz>
To: Jonathan Corbet <corbet@lwn.net>
Cc: dhowells@redhat.com, Jiri Kosina <jkosina@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: /proc/keys is not unconditionally available
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2310.1422472800.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 28 Jan 2015 19:20:00 +0000
Message-ID: <2311.1422472800@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> wrote:

> > Documentation/module-signing.txt file is referring to /proc/keys file in 
> > order to view all keys contained in the kernel's keyring. That file is not 
> > universally avialble when CONFIG_KEYS is enabled, which is confusing. The 
> > fact that the option needed for this procfs interface to exist contains 
> > "_DEBUG_" in its name makes it even more confusing. Document this fact.
> 
> Applied to the docs tree, thanks.

Can you unapply it please?  I've put an alternative patch in my set that makes
/proc/keys unconditional and Jiri has dropped this one.

David
