Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaFOQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:09:29 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaFOQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:09:27 -0400
Date: Sun, 15 Jun 2014 18:09:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>, Andi Kleen <andi@firstfloor.org>,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v6
Message-ID: <20140615160925.GG5714@two.firstfloor.org>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
 <CAPh34mfkAXwD7tbscxj7TeN48TqMRY78LyU96YzdO34CoFXLng@mail.gmail.com>
 <1402837389.1684.25.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402837389.1684.25.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 10:03:09PM +0900, Namhyung Kim wrote:
> Hi Hagen,
> 
> 2014-06-14 (토), 22:49 +0200, Hagen Paul Pfeifer:
> > Probably too late, but IMHO the subcommand "download" is unhappy
> > named. What is "downloaded"? traces? Python helper libs for
> > perf-python support, I don't know it. What about "events-download",
> > "events-database", ...
> 
> Hmm.. maybe we can add support something like above later - "perf
> download event" or "perf download blabla"

Sorry I think that's all overdesigning. Designing for unknown
possibilities is usually a bad idea.

In the unlikely case that something else was ever downloaded a new command
can be added.

> But I have a different idea - leaving perf download as a plumbing tool,
> and add --download option into the perf list to call it internally.

That would be syntactical vinegar.

> Maybe it can automatically download event file if it didn't find the
> file in the local cache.

That wasn't done intentionally, so that people who don't want
network accesses don't get them.

-Andi
