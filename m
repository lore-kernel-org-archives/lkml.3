Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaCNNBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:01:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbaCNNBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:01:33 -0400
Date: Fri, 14 Mar 2014 14:01:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf kvm: introduce --list-cmds for use by scripts
Message-ID: <20140314130129.GA5276@krava.redhat.com>
References: <1393896396-10427-1-git-send-email-artagnon@gmail.com>
 <20140305095155.GA1835@krava.brq.redhat.com>
 <CALkWK0npg=XSnB0jCN9E60MoQNskhrcuV7YYZF_4-bCKnKWLcg@mail.gmail.com>
 <CALkWK0=OigDKDZqpr5nm12jypH=Qpk2Z6JphpnVrCSZm038gOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=OigDKDZqpr5nm12jypH=Qpk2Z6JphpnVrCSZm038gOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 11:52:12AM -0400, Ramkumar Ramachandra wrote:
> Ramkumar Ramachandra wrote:
> > Jiri Olsa wrote:
> >> On Mon, Mar 03, 2014 at 08:26:36PM -0500, Ramkumar Ramachandra wrote:
> >>> Introduce
> >>>
> >>>   $ perf kvm --list-cmds
> >>>
> >>> to dump a raw list of commands for use by the completion script. In
> >>> order to do this, introduce parse_options_subcommand() for handling
> >>> subcommands as a special case in the parse-options machinery.
> 
> Jiri? How do we proceed with this?

I think Arnaldo will process it eventually ;-)
I dont have any objections..

jirka
