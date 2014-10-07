Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaJGPK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:10:57 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51957 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJGPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:10:55 -0400
Message-ID: <54340276.9070708@gmail.com>
Date: Tue, 07 Oct 2014 09:10:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf kvm stat record: print kvm specific --help output
References: <1412611998-8690-1-git-send-email-yarygin@linux.vnet.ibm.com> <1412611998-8690-2-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1412611998-8690-2-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/14, 10:13 AM, Alexander Yarygin wrote:

> +static void print_record_help(void)
> +{
> +	fprintf(stderr, "\n usage: perf kvm stat record [<options>]\n\n");
> +
> +	fprintf(stderr, "    -p, --pid <pid>      record events on existing process id\n");
> +	fprintf(stderr, "    -t, --tid <tid>      record events on existing thread id\n");
> +	fprintf(stderr, "    -r, --realtime <n>   collect data with this RT SCHED_FIFO priority\n");
> +	fprintf(stderr, "        --no-buffering   collect data without buffering\n");
> +	fprintf(stderr, "    -a, --all-cpus       system-wide collection from all CPUs\n");
> +	fprintf(stderr, "    -C, --cpu <cpu>      list of cpus to monitor\n");
> +	fprintf(stderr, "    -c, --count <n>      event period to sample\n");
> +	fprintf(stderr, "    -o, --output <file>  output file name\n");
> +	fprintf(stderr, "    -i, --no-inherit     child tasks do not inherit counters\n");
> +	fprintf(stderr, "    -m, --mmap-pages <pages>\n");
> +	fprintf(stderr, "                         number of mmap data pages\n");
> +	fprintf(stderr, "    -v, --verbose        be more verbose (show counter open errors, etc)\n");
> +	fprintf(stderr, "    -q, --quiet          don't print any message\n");
> +	fprintf(stderr, "    -D, --delay <n>      ms to wait before starting measurement after program start\n");
> +	fprintf(stderr, "    -u, --uid <user>     user to profile\n");
> +	fprintf(stderr, "        --per-thread     use per-thread mmaps\n");
> +
> +	fprintf(stderr, "\nOtherwise, it is the alias of 'perf record:'\n");
> +}

Those are all perf-record options, not perf-kvm-stat-record options. 
This usage should not repeat perf-record.

David

