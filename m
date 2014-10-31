Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbaJaPJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:09:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:34446 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:17 -0400
Date: Fri, 31 Oct 2014 16:09:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 0/8] CR4 handling improvements
Message-ID: <20141031150911.GO23531@worktop.programming.kicks-ass.net>
References: <cover.1414190806.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This looks ok I suppose, although the x86 people should pass verdict on
the first few patches.
