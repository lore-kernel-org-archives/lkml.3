Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab3GSMG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:06:26 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58588 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760239Ab3GSMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:06:24 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-65-51e92bbe61d8
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 13/23] perf tools: Introduce perf.data version 3 format
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-14-git-send-email-jolsa@redhat.com>
Date: Fri, 19 Jul 2013 21:06:22 +0900
In-Reply-To: <1374083403-14591-14-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Wed, 17 Jul 2013 19:49:53 +0200")
Message-ID: <877ggmwy81.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:49:53 +0200, Jiri Olsa wrote:
> Introducing perf.data version 3 format. No functional change,
> just introducing doc, magic bytes and the struct.
>
[SNIP]

> +perf-data-file-v3(1)

s/(1)/(5)/

The same goes to v2 doc.


> +====================
> +Following text describes version 3 of the perf data file format,
> +which is version that is currently used by perf tool.
> +
> +In version 3 we got rid of following sections:
> +  EVENT IDS
> +  EVENT ATTRIBUTES
> +  EVENT TYPES
> +
> +and keep only data and features sections. All the data
> +from above listed sections are now read from specific
> +FEATURES sections.
> +
> +benefits:
> +  - siplified header storage at the time the file is closed

s/siplified/simplified/


> +  - allowing cpu hotpluged addition/removal event IDs
> +    during the session due to 1)

What is 1) ?

Thanks,
Namhyung

