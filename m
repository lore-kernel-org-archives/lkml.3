Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaAPMj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:39:29 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:61380 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbaAPMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:39:26 -0500
Message-ID: <1389875964.4985.14.camel@x220>
Subject: Re: [PATCH] headers_check: special case seqbuf_dump()
From: Paul Bolle <pebolle@tiscali.nl>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Date: Thu, 16 Jan 2014 13:39:24 +0100
In-Reply-To: <s5h4n54ta77.wl%tiwai@suse.de>
References: <1389782899.2128.15.camel@x220> <s5h4n54ta77.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2014 12:39:24.0518 (UTC) FILETIME=[FCB6B060:01CF12B7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 12:53 +0100, Takashi Iwai wrote:
> At Wed, 15 Jan 2014 11:48:19 +0100,
> Paul Bolle wrote:
> > 2) By the way, what is actually meant by:
> >     It is no longer possible to actually link against OSSlib with this
> >     header, but we still provide these macros for programs using them.
> > 
> > Doesn't that mean compatibility to OSSlib isn't even useful?
> 
> Well, it's not about the compatibility to osslib.  The OSS seq
> user-space codes are written with these macros no matter whether to
> use osslib or not.  osslib was newer than these macros and it was
> designed to be compatible with them.

So perhaps that line should read something like:
    [...]
    header, but we still provide these macros for programs that want to
    interface with /dev/dsp and /dev/sequencer directly.

I'm making that up: I know nothing about this stuff. I'm just looking
for a way to make that comment clear to a person that wonders in, say,
2019: "What on earth is seqbuf_dump() good for?".


Paul Bolle

