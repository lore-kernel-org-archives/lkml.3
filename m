Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaIHFXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 01:23:37 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65405 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaIHFXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 01:23:34 -0400
Date: Mon, 8 Sep 2014 07:23:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
Message-ID: <20140908052329.GA30461@gmail.com>
References: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
 <1409894238-9055-3-git-send-email-ast@plumgrid.com>
 <20140906141051.GA4245@salvia>
 <CAMEtUuxPynQ4wdWDgCU+9_3_GRYn8oA4f-emcF+mqiQdLsqEWg@mail.gmail.com>
 <20140907180737.GA5057@salvia>
 <CAMEtUuxJLDu8AAsZQdtG781vwC8y60Ygdt4ji5tbeyTE8YbWbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuxJLDu8AAsZQdtG781vwC8y60Ygdt4ji5tbeyTE8YbWbQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> > I don't think the speed up of the llvm submission is a good 
> > argument, this sounds to me similar to the "please apply this 
> > patch that reserves this new netlink family in 
> > include/linux/netlink.h, I promise this new subsystem will be 
> > submitted soon though. Meanwhile this will speed up 
> > submission of my userspace software to distributions for 
> > packaging" argument.
> 
> You're not correct here. I'm not saying 'I promise it will be 
> submitted'. There _were_ already submitted. [...]

And this split-up smaller submissions was requested by David 
Miller, the networking maintainer, so if Pablo wants another 
submission format, he needs to take it up with David - we can't 
do both at once obviously.

Thanks,

	Ingo
