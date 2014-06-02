Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaFBOQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:16:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:48687 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbaFBOQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:16:11 -0400
Date: Mon, 2 Jun 2014 11:16:06 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] split BPF out of core networking
Message-ID: <20140602141606.GC2544@kernel.org>
References: <1401692506-7796-1-git-send-email-ast@plumgrid.com>
 <20140602081545.7baf4a91@lwn.net>
 <20140602092456.2114440a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602092456.2114440a@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 02, 2014 at 09:24:56AM -0400, Steven Rostedt escreveu:
> On Mon, 2 Jun 2014 08:15:45 -0500
> Jonathan Corbet <corbet@lwn.net> wrote:
 
> > On Mon,  2 Jun 2014 00:01:44 -0700
> > Alexei Starovoitov <ast@plumgrid.com> wrote:

> > > This patch set splits BPF out of core networking into generic component

> > Quick, probably dumb question: if you're going to split it out, why not
> > split it out entirely, into kernel/ or (perhaps better) lib/?  The
> > whole point seems to be that BPF is outgrowing its networking home, so
> > it seems like it might be better to make it truly generic.
 
> I believe this is what Ingo suggested as well. If it is become generic,
> it belongs in lib/

Yes, that was his suggestion, which I agree with, FWIW.

- Arnaldo
