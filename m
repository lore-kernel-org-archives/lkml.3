Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3CARoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:44:16 -0500
Received: from longford.logfs.org ([213.229.74.203]:58588 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3CARoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:44:15 -0500
Date: Fri, 1 Mar 2013 11:20:29 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] blockconsole: use CON_ALLDATA
Message-ID: <20130301162029.GB16393@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-6-git-send-email-joern@logfs.org>
 <x49txov14mp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49txov14mp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 March 2013 11:11:58 -0500, Jeff Moyer wrote:
> Joern Engel <joern@logfs.org> writes:
> 
> > Blockconsole should really see every message ever printed.  The
> > alternative is to try debugging with information like this:
> > [166135.633974] Stack:
> > [166135.634016] Call Trace:
> > [166135.634029]  <IRQ>
> > [166135.634156]  <EOI>
> > [166135.634177] Code: 00 00 55 48 89 e5 0f 1f 44 00 00 ff 15 31 49 80 00 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00
> > [166135.634384]  48 8b 14 25 98 24 01 00 48 8d 14 92 48 8d 04 bd 00 00 00 00
> 
> What was your log level set to at the time?  By default, all of the
> information for a kernel panic should show up on the console, no?

I believe it was the distro default, which should be 4.  We used to
play silly games with setting the loglevel to "just send everything".
But that applies equally to all consoles, so you could no longer type
on the console and retain your sanity at the same time.

If you and/or other people are strongly opposed to the CON_ALLDATA
patches, I can either keep them private (we will never drop them from
our kernel) or add a config option.

Jörn

--
Doubt is not a pleasant condition, but certainty is an absurd one.
-- Voltaire
