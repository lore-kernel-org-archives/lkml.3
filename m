Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbaFSQn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:43:56 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59834 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaFSQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:43:55 -0400
Message-ID: <1403196229.29394.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 9/9] perf bench: futex: Support operations for shared
 futexes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp, aswin@hp.com,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Date: Thu, 19 Jun 2014 09:43:49 -0700
In-Reply-To: <20140619164124.GH20252@kernel.org>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	 <1402942467-10671-10-git-send-email-davidlohr@hp.com>
	 <20140619164124.GH20252@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 13:41 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jun 16, 2014 at 11:14:27AM -0700, Davidlohr Bueso escreveu:
> > Unlike futex-hash, requeuing and wakeup benchmarks do not support
> > shared futexes, limiting the usefulness of the programs. Correct
> > this, and allow using the local -S parameter. The default remains
> > using private futexes.
> 
> Also isn't this benchmark related to something Darren did? Just checking
> why he isn't in the CC list, Darren, does this all sound fine to you?

Darren is well aware of these benchmarks, and we've discussed the topic
in the past. This change doesn't conflict with what he maintains in the
futextest suite.

Thanks,
Davidlohr

