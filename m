Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3LCQIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:08:04 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51744 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3LCQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:08:02 -0500
Message-ID: <529E01DF.8070507@gmail.com>
Date: Tue, 03 Dec 2013 09:07:59 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/7] perf script: Add an option to print the source line
 number
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com> <1386055390-13757-3-git-send-email-adrian.hunter@intel.com> <529E00F6.7000802@gmail.com>
In-Reply-To: <529E00F6.7000802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/13, 9:04 AM, David Ahern wrote:

> What about callchains?

I think you can handle callcahins and IP by moving the srcline printing 
into perf_evsel__print_ip() and adding a PRINT_IP_OPT_SRCLINE option.

David

