Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbaGCVsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:48:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:54041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbaGCVsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:48:15 -0400
Date: Thu, 3 Jul 2014 18:48:11 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCHES 0/7] Add support for showing headers in the hist
 browser.
Message-ID: <20140703214811.GC11267@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404423780-24026-1-git-send-email-acme@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 03, 2014 at 06:42:53PM -0300, Arnaldo Carvalho de Melo escreveu:
> 	Please let me know if you are ok with it and if I can have your
> Acked-by and perhaps Tested-by tags for the code I wrote.
> 
> 	Namhyung, since you reviewed the previous patchkit, I'd like to know
> if I can keep the acked-by and perhaps a tested-by too. This should address the
> problems that Jiri pointed out in our private conversation.

Forgot to mention, it is available in this branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
  tmp.perf/ui/show_headers

- Arnaldo
