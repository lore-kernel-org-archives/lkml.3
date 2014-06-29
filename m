Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaF2Qwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:52:46 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65441 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaF2Qwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:52:45 -0400
Message-ID: <53B0445C.2090607@gmail.com>
Date: Sun, 29 Jun 2014 10:52:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 16/18] perf tools: Add debug prints for ordered events
 queue
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <1403103539-16807-17-git-send-email-jolsa@kernel.org> <53AE2DEA.2000002@gmail.com> <20140629164652.GD1407@krava.redhat.com>
In-Reply-To: <20140629164652.GD1407@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/14, 10:46 AM, Jiri Olsa wrote:
> On Fri, Jun 27, 2014 at 08:52:26PM -0600, David Ahern wrote:
>> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
>>> Adding some prints for ordered events queue, to help
>>> debug issues.
>>
>> went to enable this and it is really odd to have to edit a config file to
>> enable debugging. How about hooking it into verbose option? Maybe like
>> multiple levels of -v or -v <val> or -v queue.
>
> seems like verbose option factoring.. in future ;-) I can live
> without this patch though.. it was mainly for testing my changes

It was quite useful to see how various data sets were stressing the 
ordered samples queue. For example 'perf record -g' and a kernel build 
stressed it more than the record on the 'perf bench'.

David

