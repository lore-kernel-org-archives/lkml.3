Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3G0M2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 08:28:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3G0M23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 08:28:29 -0400
Date: Sat, 27 Jul 2013 14:27:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/9] perf tools: add support for reading object code
Message-ID: <20130727122752.GB1038@krava.brq.redhat.com>
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 05:01:21PM +0300, Adrian Hunter wrote:
> Hi
> 
> Here are some patches that add support for reading object code from vmlinux,
> kernel modules and /proc/kcore.

hum.. looks like it's based on your previous fixies
plus some from David? I couldn't get it cleanly applied
on latest Arnaldo's perf/core.

Please make it clear or better provide a git tree/branch ;-)

thanks,
jirka
