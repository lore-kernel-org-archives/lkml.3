Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3AZSzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 13:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3AZSzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:55:20 -0500
Date: Sat, 26 Jan 2013 19:53:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130126185328.GA1264@krava.brq.redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 06:27:46PM +0100, Jiri Olsa wrote:
> hi,
> adding sysfs attribute to specify the maximum allowed value
> for perf_event_attr::precise_ip field.
> 
> Adding functionality for simple 'precise' term to get the
> maximum allowed value for perf_event_attr::precise_ip field.
> 
> And finally adding several precise automated tests.

Available also at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
  perf/precise3

jirka
