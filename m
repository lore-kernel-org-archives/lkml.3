Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbaLKRsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:48:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507AbaLKRso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:48:44 -0500
Date: Thu, 11 Dec 2014 18:15:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/8] perf data: Add perf data to CTF conversion support
Message-ID: <20141211171519.GC26788@krava.redhat.com>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
 <1418310749-22267-4-git-send-email-jolsa@kernel.org>
 <5489CF1C.5090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489CF1C.5090606@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 10:06:36AM -0700, David Ahern wrote:
> On 12/11/14 8:12 AM, Jiri Olsa wrote:
> >To convert perf.data into CTF run:
> >   $ perf data convert --to-ctf=./ctf-data/
> 
> 
> Are you expecting to need a --from-ctf? if not should that just be --ctf?
> 

I guess the motivation (unintentional) was more to have the 'sentence' like command ;-)

  perf data convert --to-ctf ..

IMO it's more descriptive then:

  perf data convert --ctf

jirka
