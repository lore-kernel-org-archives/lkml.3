Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbaIINMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:12:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:51868 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaIINMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:12:53 -0400
Date: Tue, 9 Sep 2014 10:12:39 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [GIT PULL 00/13] perf/core improvements and fixes
Message-ID: <20140909131239.GJ2773@kernel.org>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
 <540EBED4.70900@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540EBED4.70900@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 09, 2014 at 11:48:20AM +0300, Adrian Hunter escreveu:
> It looks like I reposted older versions by mistake on 31 July.
> Very sorry :-(
> 
> The originals were changed as described here:
> 
> 	http://marc.info/?l=linux-kernel&m=140621020918615
> 	http://marc.info/?l=linux-kernel&m=140618721010170

No problem, the good thing is that we're almost getting it all in. I'll
rework the branch and resubmit, Ingo, is that OK with you? Or have you
already pulled and we should instead send a patch on top, fixing the
problem?

- Arnaldo
