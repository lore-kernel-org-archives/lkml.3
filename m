Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3CNIXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:23:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43886 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3CNIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:23:12 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-26-514188ed25fa
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] perf util: Change trace info output file name
References: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
	<1363173585-9754-7-git-send-email-namhyung@kernel.org>
	<51408364.8050104@gmail.com>
Date: Thu, 14 Mar 2013 17:23:08 +0900
In-Reply-To: <51408364.8050104@gmail.com> (David Ahern's message of "Wed, 13
	Mar 2013 07:47:16 -0600")
Message-ID: <871ubil79v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 13 Mar 2013 07:47:16 -0600, David Ahern wrote:
> On 3/13/13 5:19 AM, Namhyung Kim wrote:
>> -static const char *output_file = "trace.info";
>> +static const char *output_file = "perf.data";
>>   static int output_fd;
>
> Not really needed. Only use is a couple of die() calls. Since the file
> name is not used on the open the die message would be misleading.

I know.  But it just looked too ugly to me. :)

I'm fine with dropping this one.  I think I'm going to get rid of these
die() and something_or_die() calls soonish..

Thanks,
Namhyung
