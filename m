Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3EJOHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:07:18 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50688 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3EJOHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:07:16 -0400
Message-ID: <518CFF0A.7000002@gmail.com>
Date: Fri, 10 May 2013 08:07:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 04/13] perf session: export a few functions for event
 processing
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com> <1368073909-8825-5-git-send-email-dsahern@gmail.com> <20130510121459.GH1040@krava.brq.redhat.com>
In-Reply-To: <20130510121459.GH1040@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/13 6:14 AM, Jiri Olsa wrote:
>> @@ -494,8 +494,8 @@ static int perf_session_deliver_event(struct perf_session *session,
>>   				      struct perf_tool *tool,
>>   				      u64 file_offset);
>>
>> -static int flush_sample_queue(struct perf_session *s,
>> -			       struct perf_tool *tool)
>> +int flush_sample_queue(struct perf_session *s,
>> +		       struct perf_tool *tool)
>
> hm, can't see flush_sample_queue being used globaly

oops, moved to finish_round and forgot to remove this export.

David

