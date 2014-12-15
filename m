Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaLOPOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:14:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaLOPOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:14:04 -0500
Date: Mon, 15 Dec 2014 16:13:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 00/22] perf tools: Introduce an abstraction for
 Instruction Tracing
Message-ID: <20141215151306.GA16737@krava.redhat.com>
References: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com>
 <548B1425.7090500@gmail.com>
 <20141212185324.GF9845@kernel.org>
 <548EA52B.5060401@intel.com>
 <548EF9C1.2070505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548EF9C1.2070505@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 08:09:53AM -0700, David Ahern wrote:
> On 12/15/14 2:08 AM, Adrian Hunter wrote:
> >On 12/12/14 20:53, Arnaldo Carvalho de Melo wrote:
> >>Em Fri, Dec 12, 2014 at 09:13:25AM -0700, David Ahern escreveu:
> >>>On 12/12/14 6:47 AM, Adrian Hunter wrote:
> >>>>Here is V3 of some more preparatory patches for Intel PT
> >>>>that introduce an abstraction for Instruction tracing.
> >>
> >>>This is an x86-Intel only feature correct? If that is the case then the code
> >>>should be not compiled for other architectures.
> >
> >It is not that simple. In the case of recording, it is not needed for
> >architectures that don't support it, but in the case of session processing
> >any architecture can (or should be able to) process the perf.data file of
> >any other architecture.
> 
> Understood. perf is a kitchen sink tool and the size of binaries for
> embedded deployments is getting out of hand. e.g., for our PPC based systems
> the entire root filesystem is 46M with perf taking up almost 3M of that
> (stripped size too). New features need config options so user's can decide
> the feature scope of what they are building. And we need to get the kconfig
> style builds committed as well.

yep.. I'm on that kconfig stuff ;-)

jirka
