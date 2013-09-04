Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620Ab3IDVqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:46:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60267 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558Ab3IDVqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:46:03 -0400
Message-ID: <5227AA13.7090300@gmail.com>
Date: Wed, 04 Sep 2013 15:45:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf tools: fix parsing with no sample_id_all bit
 set
References: <1378325897-3840-1-git-send-email-adrian.hunter@intel.com> <1378325897-3840-3-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1378325897-3840-3-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/13 2:18 PM, Adrian Hunter wrote:
> The perf_evlist__event2evsel() is changed to handle
> non-sample events (such as mmap events) that have no
> id sample appended i.e. when sample_id_all is not set.
>
> Note that such events have a fixed format, so that
> the selected event (evsel) they are associated with
> is immaterial.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Fixes the regression. Thanks for the fix.

Tested-and-Acked-by: David Ahern <dsahern@gmail.com>

Arnaldo: this needs to go in perf/urgent and pushed into 3.12.

David
