Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaCQEuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:50:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43159 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaCQEuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:50:15 -0400
X-AuditID: 9c93016f-b7b09ae000000557-53-53267f0549d9
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/5] perf tests: Add tip/pid mmap automated tests
In-Reply-To: <1394805606-25883-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 14 Mar 2014 15:00:02 +0100")
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
	<1394805606-25883-2-git-send-email-jolsa@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 17 Mar 2014 13:50:12 +0900
Message-ID: <87iordtomz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 14 Mar 2014 15:00:02 +0100, Jiri Olsa wrote:
> +static int thread_init(struct thread_data *td)
> +{
> +	void *map;
> +
> +	map = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
> +		   MAP_SHARED|MAP_ANONYMOUS, -1, 0);

Shouldn't it be an executable mapping to be found by MAP__FUNCTION?

Thanks,
Namhyung
