Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3LKNzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:55:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58249 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LKNzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:55:19 -0500
Date: Wed, 11 Dec 2013 10:54:51 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
Message-ID: <20131211135451.GB1458@ghostprotocols.net>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-2-git-send-email-bp@alien8.de>
 <52A7C3E7.301@gmail.com>
 <20131211095626.GA21683@pd.tnic>
 <20131211123159.GR8098@ghostprotocols.net>
 <20131211132443.GA3101@gmail.com>
 <20131211133033.GG21683@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211133033.GG21683@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 02:30:33PM +0100, Borislav Petkov escreveu:
> On Wed, Dec 11, 2013 at 02:24:43PM +0100, Ingo Molnar wrote:
> > > I'll try to keep this moving today, together with the start of
> > > tools/lib/symbol/ ;-)
> >
> > That looks good to me as well. Lets see how well this whole
> > approach works in practice. Please be on the lookout for
> > anomalies/inconsistencies as the set of topics increases.
> 
> Right, I'll CC the whole list on future submissions so that such
> anomalies are caught in time.
> 
> @acme: if you're having too much trouble keeping this moving, let me
> know and I'll rebase.

Not needed, there is even more flux happening as I merge bits from the
(big) IPT patchset, so I'll cope.

Will probably send a new patchset with it later today or tomorrow.

Thanks for your effort on this!

- Arnaldo
