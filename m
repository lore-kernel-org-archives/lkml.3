Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab3IFRj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:39:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54130 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IFRjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:39:54 -0400
Message-ID: <522A1365.2020504@gmail.com>
Date: Fri, 06 Sep 2013 11:39:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf kvm: fix sample_type manipulation
References: <1378450134-28982-1-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1378450134-28982-1-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/13 12:48 AM, Adrian Hunter wrote:
> Manipulating the sample_type of an evsel requires
> the use of:
> 	perf_evsel__set_sample_bit()
> and	perf_evsel__reset_sample_bit()
>
> Manipulating the sample type of an evlist requires
> the id position to be recalculated.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>


Fixes the regression. Thanks for taking care of it

Tested-by-and-Acked-by: David Ahern <dsahern@gmail.com>
