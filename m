Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaCVVMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:12:38 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:58162 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbaCVVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:12:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsXADj8LVNbslpV/2dsb2JhbABZgwY7gg5+E6cOmRMCAoEUF3SCJQEBAQMBOhwjBQsIAw4KLjkeBhOHcQwBzgQXjnoHhDgBA45SiXcBgTKJJ4dYgy48
Date: Sat, 22 Mar 2014 22:13:44 +0100
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-Id: <20140322221344.62e8addc4facbe799b186496@skynet.be>
In-Reply-To: <20140322105524.7baec73a.akpm@linux-foundation.org>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	<20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
	<20140322170322.GA23583@thunk.org>
	<20140322101512.eaeb542b.akpm@linux-foundation.org>
	<20140322172606.GB23583@thunk.org>
	<20140322173207.GC23583@thunk.org>
	<20140322105524.7baec73a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014 10:55:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 22 Mar 2014 13:32:07 -0400 tytso@mit.edu wrote:
> 
> > On Sat, Mar 22, 2014 at 01:26:06PM -0400, tytso@MIT.EDU wrote:
> > > > Well.  Converting an existing retry-for-ever caller to GFP_NOFAIL is
> > > > good.  Adding new retry-for-ever code is not good.
> > 
> > Oh, and BTW --- now that checkpatch.pl now flags an warning whenever
> > GFP_NOFAIL is used
> 
> I don't know what the basis for this NOFAIL-is-going-away theory could
> have been.  What's the point in taking a centrally implemented piece of
> logic and splattering its implementation out to tens of different
> callsites?
> 
> Obviously I was asleep when I merged that checkpatch change.

Exactly where confusion came from, thanks !

Fabian
