Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935374Ab3DKQpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:45:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934125Ab3DKQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:45:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130411154806.GU10155@atomide.com>
References: <20130411154806.GU10155@atomide.com> <20130411132739.32763.82609.stgit@warthog.procyon.org.uk> <20130411133058.32763.5466.stgit@warthog.procyon.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, viro@ZenIV.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 25/26] arm: Don't use create_proc_read_entry() [RFC]
Date: Thu, 11 Apr 2013 17:45:25 +0100
Message-ID: <13448.1365698725@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren <tony@atomide.com> wrote:

> Looks like the mach-omap1/pm.c part we can make into
> a debugfs entry as it only contains PM debug data. But
> that we can do after this patch.

If you have a patch to do that, I can substitute it for this one.

David
