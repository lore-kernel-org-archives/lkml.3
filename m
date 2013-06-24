Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FXTYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:24:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58175 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3FXTYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:24:10 -0400
Date: Mon, 24 Jun 2013 21:24:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 02/14] perf: Add persistent events
Message-ID: <20130624192404.GA24827@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-3-git-send-email-rric@kernel.org>
 <20130624092807.GM28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130624092807.GM28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 11:28:07AM +0200, Peter Zijlstra wrote:
> I find this patch incomplete for its asymmetric; there a dec, but not an
> implied inc.

There's one in perf_mmap_open.

Basically the idea was to pull up the ->mmap_count decrement (haha,
sounds like excrement :-)) and not deallocate the ring buffers for a
persistent event.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
