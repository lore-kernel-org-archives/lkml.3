Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbbA1U1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:27:33 -0500
Received: from tex.lwn.net ([70.33.254.29]:35230 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbbA1U1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:27:30 -0500
Date: Wed, 28 Jan 2015 12:33:18 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: David Howells <dhowells@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: /proc/keys is not unconditionally available
Message-ID: <20150128123318.5b2b0ceb@lwn.net>
In-Reply-To: <2311.1422472800@warthog.procyon.org.uk>
References: <20150128121207.59254055@lwn.net>
	<alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz>
	<2311.1422472800@warthog.procyon.org.uk>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 19:20:00 +0000
David Howells <dhowells@redhat.com> wrote:

> > Applied to the docs tree, thanks.  
> 
> Can you unapply it please?  I've put an alternative patch in my set that makes
> /proc/keys unconditional and Jiri has dropped this one.

OK, done.

jon
