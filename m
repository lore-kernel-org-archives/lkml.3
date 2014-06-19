Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbaFSRCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:02:06 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:56174 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaFSRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:02:05 -0400
Message-ID: <1403197317.29394.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 6/9] perf bench: futex: Replace --silent option with
 global --format
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp, aswin@hp.com,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 10:01:57 -0700
In-Reply-To: <20140619163851.GG20252@kernel.org>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	 <1402942467-10671-7-git-send-email-davidlohr@hp.com>
	 <20140619163851.GG20252@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 13:38 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jun 16, 2014 at 11:14:24AM -0700, Davidlohr Bueso escreveu:
> > Using the already existing '--format simple' option in perf-bench
> > is/should be equivalent to disabling any verbose output. Replace
> > it and free up the -s option specific to the futex benchmark.
> 
> Isn't this much longer?

It is, and to be honest I detest the whole --format option. But its
already there and I really want to make use of global parameters in
order to recycle options that are benchmark-specific. What I'd really
like is to replace it with --silent and just have perf spit out the raw
data (for scripting). But that would be too disruptive to users, imho.
Does it matter? I dunno.

> I haven't seen any patch in this series wanting to use -s.
> 
> Ingo, are you Ok with this?
> 
> I.e. I'm just trying to be careful when changing existing cmd line args,
> perhaps someone is used to this, who knows, and at least for me,
> --silent is way, way more clear than '--format simple', that says
> nothing to me.

If we can get away with it then lets.

Thanks,
Davidlohr

