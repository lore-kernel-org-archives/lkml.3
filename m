Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3EZAKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:10:15 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46458 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab3EZAKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:10:11 -0400
Message-ID: <51A152DF.8030807@gmail.com>
Date: Sat, 25 May 2013 18:10:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 07/13] perf kvm: split out tracepoints from record args
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com> <1368073909-8825-8-git-send-email-dsahern@gmail.com> <20130510123921.GI1040@krava.brq.redhat.com>
In-Reply-To: <20130510123921.GI1040@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/13 6:39 AM, Jiri Olsa wrote:

>> +	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
>> +		rec_argv[i++] = "-e";
>> +		rec_argv[i++] = STRDUP_FAIL_EXIT(kvm_events_tp[j]);
>> +	}
>> +
>
> just curious.. I dont understand why it needs to be dynamic?
>
> jirka
>

passing a new set of args to cmd_record -- what the user passed in 
augmented with the tracepoints needed for kvm stat.

David
