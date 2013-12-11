Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3LKNYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:24:49 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51334 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3LKNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:24:48 -0500
Date: Wed, 11 Dec 2013 14:24:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
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
Message-ID: <20131211132443.GA3101@gmail.com>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-2-git-send-email-bp@alien8.de>
 <52A7C3E7.301@gmail.com>
 <20131211095626.GA21683@pd.tnic>
 <20131211123159.GR8098@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211123159.GR8098@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Wed, Dec 11, 2013 at 10:56:26AM +0100, Borislav Petkov escreveu:
> > On Tue, Dec 10, 2013 at 06:46:15PM -0700, David Ahern wrote:
> > > no longer applies to the moving target that is acme's tree.
> > 
> > Of course it doesn't, with all the junk flood going in there :-)
> > 
> > Btw, this is why I'm planning on sending only a small amount of patches
> > and hoping that acme picks them up quickly. :)
> 
> I'll try to keep this moving today, together with the start of
> tools/lib/symbol/ ;-)

That looks good to me as well. Lets see how well this whole approach 
works in practice. Please be on the lookout for 
anomalies/inconsistencies as the set of topics increases.

Thanks,

	Ingo
