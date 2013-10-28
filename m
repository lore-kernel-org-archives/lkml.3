Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3J1M7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:59:04 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34550 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3J1M7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:59:02 -0400
Date: Mon, 28 Oct 2013 13:59:00 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131028125900.GA278@x4>
References: <20131026122414.GA25026@gmail.com>
 <20131028082848.GA276@x4>
 <20131028090236.GA274@x4>
 <20131028093430.GB274@x4>
 <20131028123411.GB16948@ghostprotocols.net>
 <20131028124218.GD16948@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028124218.GD16948@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.10.28 at 09:42 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 28, 2013 at 09:34:11AM -0300, Arnaldo Carvalho de Melo escreveu:
> > And then, when reverting it, Stephane forgot to match the number number
> > of expected entries to be matched/assigned from 8 to 5, can you try with
> > the following patch instead?
> 
> Does the wording on this commit log sounds about right to you?

Yes. Your patch is fine. Thanks.

-- 
Markus
