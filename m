Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaANVHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:07:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:26651 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaANVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:07:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="438838030"
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/5] perf report: Add --percentage option
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
	<1389674599-28227-4-git-send-email-namhyung@kernel.org>
Date: Tue, 14 Jan 2014 13:07:00 -0800
In-Reply-To: <1389674599-28227-4-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 14 Jan 2014 13:43:17 +0900")
Message-ID: <87zjmy2ryj.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@kernel.org> writes:
>  
> +--percentage::
> +	Determine how to display the overhead percentage of filtered
> entries.

This should describe also what a "filtered entry" exactly is. It's not clear
even to me.

-Andi

> +	"relative" means it's relative to filtered entries only so that the
> +	sum of shown entries will be always 100%.  "absolute" means it retains
> +	original value before and after the filter applied.
> +

-- 
ak@linux.intel.com -- Speaking for myself only
