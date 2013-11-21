Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3KUHeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 02:34:15 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:34459 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3KUHeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 02:34:14 -0500
Date: Thu, 21 Nov 2013 08:34:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121073410.GA16971@gmail.com>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384984585-24300-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> Move to generic library and kill magic.h as it is needed only in fs.h.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

Ouch, the naming is horrible, what does 'lk' stand for? Please rename 
it to something sensible before it spreads.

libkernel.so and tools/lib/kernel/ would be perfect I think.

Thanks,

	Ingo
