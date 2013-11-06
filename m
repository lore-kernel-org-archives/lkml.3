Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3KFRvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:51:55 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53928 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3KFRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:51:54 -0500
Message-ID: <527A81B8.7040505@gmail.com>
Date: Wed, 06 Nov 2013 10:51:52 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/2] perf record: mmap output file - v3
References: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/13, 11:31 AM, Jiri Olsa wrote:
> hi,
> after discussion with David, sending his change
> updated into the new data file object.
>
> David's original post:
>    http://marc.info/?l=linux-kernel&m=138180575328977&w=2
>
> Here's the change:
>    git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>    perf/mmap1
>

Not having any luck with these patches. Basic use case:

perf trace record -a -- sleep 5
perf trace --summary

With your patches I get a parse error. With my latest versions 
everything works clean.

David

