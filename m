Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaJEISq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 04:18:46 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47389 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaJEISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 04:18:43 -0400
Message-ID: <5430FEDA.2070807@linux.vnet.ibm.com>
Date: Sun, 05 Oct 2014 13:48:34 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 3/5] perf/sdt: Show SDT cache contents
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024815.28985.8980.stgit@hemant-fedora> <542E9CAC.3080108@hitachi.com>
In-Reply-To: <542E9CAC.3080108@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100508-3568-0000-0000-00000045FC32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/03/2014 06:25 PM, Masami Hiramatsu wrote:
> (2014/10/01 11:48), Hemant Kumar wrote:
>> @@ -35,10 +45,13 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>>   		OPT_CALLBACK('a', "add", NULL, "filename",
>>   			     "add SDT events from a file.",
>>   			     opt_add_sdt_events),
>> +		OPT_CALLBACK_NOOPT('s', "dump", NULL, "show SDT events",
>> +				   "Read SDT events from cache and display.",
>> +				   opt_show_sdt_events),
> Just one note here. -s and --dump are a bit odd. how about using -D for short ops?
>
> Thank you,
>

Yeah, will use -D then! :)

-- 
Thanks,
Hemant Kumar

