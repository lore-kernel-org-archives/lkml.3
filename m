Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3EIPFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:05:31 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61380 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3EIPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:05:30 -0400
Message-ID: <518BBB30.1070003@gmail.com>
Date: Thu, 09 May 2013 09:05:20 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
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
References: <1367847833-4932-1-git-send-email-Waiman.Long@hp.com> <20130507093031.GA1076@krava.brq.redhat.com> <518A72E3.6070606@hp.com> <20130509101915.GC1628@krava.brq.redhat.com> <518BB6AF.3020003@hp.com>
In-Reply-To: <518BB6AF.3020003@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 8:46 AM, Waiman Long wrote:
> I am sorry that I forgot to rerun checkpatch.pl again after changing the
> argument type from int to bool.

You can edit/create .git/hooks/pre-commit and have it run checkpatch.pl 
so you don't forget:

#!/bin/bash
exec git diff --cached | scripts/checkpatch.pl --no-signoff -q -

If it spits out warnings that are ok, add -n to git-commit to bypass.

David

