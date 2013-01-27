Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3A0NPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:15:01 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:49742 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab3A0NO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:14:56 -0500
Date: Sun, 27 Jan 2013 14:14:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers
 v2
Message-ID: <20130127131451.GE3933@gmail.com>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
 <1359151245-13179-5-git-send-email-andi@firstfloor.org>
 <20130126115402.GA13445@gmail.com>
 <20130126210000.GK30577@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126210000.GK30577@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Sat, Jan 26, 2013 at 12:54:02PM +0100, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Implement the TSX transaction and checkpointed transaction 
> > > qualifiers for Haswell. This allows e.g. to profile the number 
> > > of cycles in transactions.
> > 
> > The changelog should explain why this is a basic feature 
> > that is a must-have to have basic perf support. (i.e. 
> > default 'perf record', 'perf report', 'perf stat' and 'perf 
> > top' works and is meaningful.)
> 
> The patch is not needed for primitive cycle sampling only.

So please re-send a truly minimal hw-enabling series first, as 
requested - a minimal series that enables most of the everyday 
usecases.

> These qualifiers are a fundamental feature for any TSX tuning.

Any new, Haswell-specific profiling features should obviously be 
in a second (or third) series of patches.

Thanks,

	Ingo
