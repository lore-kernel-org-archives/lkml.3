Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3LKNam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:30:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37412 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3LKNal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:30:41 -0500
Date: Wed, 11 Dec 2013 14:30:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20131211133033.GG21683@pd.tnic>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-2-git-send-email-bp@alien8.de>
 <52A7C3E7.301@gmail.com>
 <20131211095626.GA21683@pd.tnic>
 <20131211123159.GR8098@ghostprotocols.net>
 <20131211132443.GA3101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131211132443.GA3101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 02:24:43PM +0100, Ingo Molnar wrote:
> > I'll try to keep this moving today, together with the start of
> > tools/lib/symbol/ ;-)
>
> That looks good to me as well. Lets see how well this whole
> approach works in practice. Please be on the lookout for
> anomalies/inconsistencies as the set of topics increases.

Right, I'll CC the whole list on future submissions so that such
anomalies are caught in time.

@acme: if you're having too much trouble keeping this moving, let me
know and I'll rebase.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
