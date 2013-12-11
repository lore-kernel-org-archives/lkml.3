Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3LKMcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:32:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55737 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3LKMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:32:19 -0500
Date: Wed, 11 Dec 2013 09:31:59 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
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
Message-ID: <20131211123159.GR8098@ghostprotocols.net>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-2-git-send-email-bp@alien8.de>
 <52A7C3E7.301@gmail.com>
 <20131211095626.GA21683@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211095626.GA21683@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 10:56:26AM +0100, Borislav Petkov escreveu:
> On Tue, Dec 10, 2013 at 06:46:15PM -0700, David Ahern wrote:
> > no longer applies to the moving target that is acme's tree.
> 
> Of course it doesn't, with all the junk flood going in there :-)
> 
> Btw, this is why I'm planning on sending only a small amount of patches
> and hoping that acme picks them up quickly. :)

I'll try to keep this moving today, together with the start of
tools/lib/symbol/ ;-)

- Arnaldo
