Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaDOSRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:17:36 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43686 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaDOSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:17:31 -0400
Message-ID: <534D77B2.1070404@gmail.com>
Date: Tue, 15 Apr 2014 12:17:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/5] perf tools: Reference count map_groups objects
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com> <1397490723-1992-4-git-send-email-jolsa@redhat.com> <534C193A.2000806@gmail.com> <20140415095657.GC1700@krava.brq.redhat.com>
In-Reply-To: <20140415095657.GC1700@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/14, 3:56 AM, Jiri Olsa wrote:
>
> hum.. I think using atomic type is not enough, we'd need
> to make map_groups__put/get atomic as well
>
> not sure what's the support in user space for that.. will check
>
> also not to be negative, but libperf is not thread safe anyway, right? ;-)

should be. pretty certain there have been bug reports (e.g, perf-top) 
that stumble onto problems and they get fixed.

David

