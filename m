Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaJUOps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:45:48 -0400
Received: from tex.lwn.net ([70.33.254.29]:46077 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbaJUOpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:45:47 -0400
Date: Tue, 21 Oct 2014 10:45:45 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] doc for 3.18 merge window
Message-ID: <20141021104545.406c8198@lwn.net>
In-Reply-To: <alpine.LNX.2.00.1410202106330.24255@pobox.suse.cz>
References: <alpine.LNX.2.00.1410070008540.31343@pobox.suse.cz>
	<1413809129.17703.13.camel@x41>
	<alpine.LNX.2.00.1410202106330.24255@pobox.suse.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 21:08:30 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> > A possible fix is discussed in https://lkml.org/lkml/2014/10/8/538 .  
> 
> Jonathan, will you take care of this (now that ad3118b9861 is in)?

OK, I've applied the fix with the extra space suggested by Paul.  You
should see it in the next linux-next.

jon
