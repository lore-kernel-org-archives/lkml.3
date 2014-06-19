Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbaFSRFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:05:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:52110 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaFSRFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:05:15 -0400
Date: Thu, 19 Jun 2014 14:05:07 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp, aswin@hp.com,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 9/9] perf bench: futex: Support operations for shared
 futexes
Message-ID: <20140619170507.GA31524@kernel.org>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
 <1402942467-10671-10-git-send-email-davidlohr@hp.com>
 <20140619164124.GH20252@kernel.org>
 <1403196229.29394.10.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403196229.29394.10.camel@buesod1.americas.hpqcorp.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 19, 2014 at 09:43:49AM -0700, Davidlohr Bueso escreveu:
> On Thu, 2014-06-19 at 13:41 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jun 16, 2014 at 11:14:27AM -0700, Davidlohr Bueso escreveu:
> > > Unlike futex-hash, requeuing and wakeup benchmarks do not support
> > > shared futexes, limiting the usefulness of the programs. Correct
> > > this, and allow using the local -S parameter. The default remains
> > > using private futexes.
> > 
> > Also isn't this benchmark related to something Darren did? Just checking
> > why he isn't in the CC list, Darren, does this all sound fine to you?
> 
> Darren is well aware of these benchmarks, and we've discussed the topic
> in the past. This change doesn't conflict with what he maintains in the
> futextest suite.

Ok, thanks, just checking :-)

- Arnaldo
