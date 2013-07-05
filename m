Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3GERpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:45:11 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37540 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3GERpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:45:09 -0400
Message-ID: <51D7061A.2060000@hp.com>
Date: Fri, 05 Jul 2013 13:44:58 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2] perf record: fix symbol processing bug and greatly
 improve performance
References: <1368110568-64714-1-git-send-email-Waiman.Long@hp.com> <20130510081214.GA6848@gmail.com> <51D6FDBD.6010606@hp.com> <20130705172637.GA16414@ghostprotocols.net>
In-Reply-To: <20130705172637.GA16414@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:26 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 05, 2013 at 01:09:17PM -0400, Waiman Long escreveu:
>> On 05/10/2013 04:12 AM, Ingo Molnar wrote:
>>> * Waiman Long<Waiman.Long@hp.com>   wrote:
>>>>   3 files changed, 11 insertions(+), 4 deletions(-)
>>> Acked-by: Ingo Molnar<mingo@kernel.org>
>> Thank for the Ack. Will that patch go into v3.11?
> I'm back at processing patches, I'm putting everything on the perf/core
> branch and afterwards will go thru the queue looking for pure bug fixex
> to put on perf/urgent and send to Ingo.
>
> - Arnaldo

Thank for the clarification. I would really like to see it merged as I 
don't want to manually merge it every time when I build the perf binary 
with the latest kernel source.

Regards,
Longman
