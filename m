Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364Ab3GSNCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:02:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56765 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3GSNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:02:43 -0400
X-AuditID: 9c930179-b7c49ae000000e68-bb-51e938f1b8aa
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 22/23] perf tools: Add multi file '-M' option for record command
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-23-git-send-email-jolsa@redhat.com>
Date: Fri, 19 Jul 2013 22:02:41 +0900
In-Reply-To: <1374083403-14591-23-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Wed, 17 Jul 2013 19:50:02 +0200")
Message-ID: <87txjqvh1q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:50:02 +0200, Jiri Olsa wrote:
> Adding multi file '-M' option for record command to store
> split event data into multiple files based on the file
> size specified as an argument to the option.

It seems you need to update the doc too. :)

Thanks,
Namhyung
