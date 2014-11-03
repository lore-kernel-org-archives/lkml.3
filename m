Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaKCVN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:13:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:59813 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaKCVNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:13:54 -0500
Date: Mon, 3 Nov 2014 18:13:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/7] perf tools: Add a thread stack for synthesizing call
 chains
Message-ID: <20141103211349.GD18464@kernel.org>
References: <1414678188-14946-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414678188-14946-1-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 30, 2014 at 04:09:41PM +0200, Adrian Hunter escreveu:
> Here are the thread stack patches again.  Please let me
> know if you want more explanation.
> 
> Changes:
> 
> 	perf tools: Add a thread stack for synthesizing call chains
> 		Added some error returns
> 		Renamed PERF_FLAGS_ to PERF_IP_FLAGS_
> 
> 	perf tools: Enhance the thread stack to output call/return data
> 		Expanded commit message
> 		Added more comments
> 

Ok, applied the series, will run some more test on a few more distros in
KVM images and probably tomorrow will push this to Ingo.

- Arnaldo
