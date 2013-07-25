Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3GYUKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:10:33 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65197 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab3GYUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:10:32 -0400
Date: Thu, 25 Jul 2013 22:10:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf tools: load kernel maps before using
Message-ID: <20130725201027.GB16719@gmail.com>
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
 <1374760890-30558-3-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374760890-30558-3-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> In order to use kernel maps to read object code, those
> maps must be adjusted to map to the dso file offset.
> Because lazy-initialzation is used, that is not done

s/initialization

> until symbols are loaded.  However the maps are first
> used by thread__find_addr_map() before symbols are loaded.
> So this patch changes thread__find_addr() to "load" kernel
> maps before using them.

Thanks,

	Ingo
