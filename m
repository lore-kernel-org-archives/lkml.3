Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab3GZP4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:56:25 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64264 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab3GZP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:56:23 -0400
Message-ID: <51F29C22.50802@gmail.com>
Date: Fri, 26 Jul 2013 09:56:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 03/15] perf tools: add pid to struct thread
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com> <1374144177-24762-4-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1374144177-24762-4-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/13 4:42 AM, Adrian Hunter wrote:
> Record pid on struct thread.  The member is named 'pid_'
> to avoid confusion with the 'tid' member which was previously
> named 'pid'.
>
> Signed-off-by: Adrian Hunter<adrian.hunter@intel.com>

Acked-by: David Ahern <dsahern@gmail.com>
