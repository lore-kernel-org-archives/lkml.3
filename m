Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3FYQFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:05:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab3FYQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:05:30 -0400
Date: Tue, 25 Jun 2013 18:04:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
Message-ID: <20130625160433.GA507@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
 <CABPqkBRoRgHUM5ahHmvYXJ1BkHncm9Z2GZkzuRFbsNfh4=HJ6g@mail.gmail.com>
 <51C98969.40401@intel.com>
 <20130625144529.GL23329@krava.brq.redhat.com>
 <51C9BA7D.1040106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C9BA7D.1040106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 09:42:53AM -0600, David Ahern wrote:
> On 6/25/13 8:45 AM, Jiri Olsa wrote:
> >AFAICS PERF_SAMPLE_STREAM_ID holds same id value as PERF_SAMPLE_ID,
> >but I guess it has some other meaning.. if not for now, maybe meant
> >something else for the future;-)  not sure
> 
> See 7f453c24.

thanks, 

hm.. I think I overlooked 'idx = 1' initialization in
__perf_evsel__calc_is_pos and the code IS actually using
PERF_SAMPLE_ID data.

jirka
