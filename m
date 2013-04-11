Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777Ab3DKQ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:57:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45121 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114Ab3DKQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:57:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18OvbG+IvcxAInrpeXFstZS
Date: Thu, 11 Apr 2013 09:57:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, viro@ZenIV.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 25/26] arm: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130411165702.GZ10155@atomide.com>
References: <20130411154806.GU10155@atomide.com>
 <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411133058.32763.5466.stgit@warthog.procyon.org.uk>
 <13448.1365698725@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13448.1365698725@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells <dhowells@redhat.com> [130411 09:50]:
> Tony Lindgren <tony@atomide.com> wrote:
> 
> > Looks like the mach-omap1/pm.c part we can make into
> > a debugfs entry as it only contains PM debug data. But
> > that we can do after this patch.
> 
> If you have a patch to do that, I can substitute it for this one.

Sure will do.

Tony
