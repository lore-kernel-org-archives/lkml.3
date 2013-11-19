Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3KSQVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:21:02 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51114 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3KSQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:21:01 -0500
Message-ID: <528B8FE8.4080301@gmail.com>
Date: Tue, 19 Nov 2013 09:20:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Allow '--inherit' as the negation of
 '--no-inherit'
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com> <1384768557-23331-3-git-send-email-adrian.hunter@intel.com> <528A8379.5030908@gmail.com> <528B1D7C.5010400@intel.com>
In-Reply-To: <528B1D7C.5010400@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/13, 1:12 AM, Adrian Hunter wrote:
> On 18/11/13 23:15, David Ahern wrote:
>> Why not cleanup the options for the commands and move all of the no-xxxx to
>> just xxxx? Anyone using no-xxxx would still just work by the existing code.
>
> Interesting idea but the short and long options are a combination, and short
> options don't work the same way e.g. -i and --no-inherit go together.
>

If inherit is on by default and -i / --inherit is the option then -i is 
a no-op and --no-inherit disables it. That's the same effect has having 
inherit on by default and an option to disable it called --no-inherit.

David
