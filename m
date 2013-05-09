Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3EIPbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:31:15 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:41193 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EIPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:31:14 -0400
Message-ID: <518BC13F.8040604@hp.com>
Date: Thu, 09 May 2013 11:31:11 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] perf: fix symbol processing bug and greatly improve performance
References: <1367847833-4932-1-git-send-email-Waiman.Long@hp.com> <20130507093031.GA1076@krava.brq.redhat.com> <518A72E3.6070606@hp.com> <20130509101915.GC1628@krava.brq.redhat.com> <518BB6AF.3020003@hp.com> <518BBB30.1070003@gmail.com>
In-Reply-To: <518BBB30.1070003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 11:05 AM, David Ahern wrote:
> On 5/9/13 8:46 AM, Waiman Long wrote:
>> I am sorry that I forgot to rerun checkpatch.pl again after changing the
>> argument type from int to bool.
>
> You can edit/create .git/hooks/pre-commit and have it run 
> checkpatch.pl so you don't forget:
>
> #!/bin/bash
> exec git diff --cached | scripts/checkpatch.pl --no-signoff -q -
>
> If it spits out warnings that are ok, add -n to git-commit to bypass.

Thanks for the tip! I will implement that in my development environment.

Regards,
Longman
