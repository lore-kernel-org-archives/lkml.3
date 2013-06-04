Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab3FDCEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:04:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52938 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab3FDCET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:04:19 -0400
X-AuditID: 9c93016f-b7cfdae000002fc1-eb-51ad4b218d14
Message-ID: <51AD4B21.6080800@lge.com>
Date: Tue, 04 Jun 2013 11:04:17 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC] perf record: Remove -A option
References: <20130603180646.GE8758@krava.brq.redhat.com>
In-Reply-To: <20130603180646.GE8758@krava.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-06-04 오전 3:06, Jiri Olsa 쓴 글:
> hi,
> the -A option (append data to the output file) for record
> command is broken, probably for some time now.
>
> Anyone interested in this functionality? As we discussed
> this with Arnaldo he and I would vote for removal.

+1 for removal.

Thanks,
Namhyung

