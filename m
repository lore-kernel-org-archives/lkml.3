Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3KRVPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:15:51 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52464 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:15:47 -0500
Message-ID: <528A8379.5030908@gmail.com>
Date: Mon, 18 Nov 2013 14:15:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Allow '--inherit' as the negation of
 '--no-inherit'
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com> <1384768557-23331-3-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1384768557-23331-3-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/13, 2:55 AM, Adrian Hunter wrote:
> Long options can be negated by prefixing them
> with 'no-'.  However options that already start
> with 'no-', such as '--no-inherit' result in ugly
> double 'no's.  Avoid that by accepting that the
> removal of 'no-' also negates the long option.
>

Why not cleanup the options for the commands and move all of the no-xxxx 
to just xxxx? Anyone using no-xxxx would still just work by the existing 
code.

David
