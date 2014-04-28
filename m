Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaD1LEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaD1LEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:04:42 -0400
Date: Mon, 28 Apr 2014 13:00:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 1/3] perf tools: Cache register accesses for unwind
 processing
Message-ID: <20140428110003.GA18628@krava.brq.redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
 <1397756352-26694-2-git-send-email-jolsa@redhat.com>
 <535E2FDC.2020309@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E2FDC.2020309@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 12:39:24PM +0200, Christian Borntraeger wrote:

SNIP

> >  {
> > 
> 
> Want such a speedup, 
> but it does not compile on my s390x system:

the speed up is for DWARF unwind report, which is not yet
supported on s390x perf.. still it should compile ;-)

I'll try to get some s390x and make a fix

thanks,
jirka
