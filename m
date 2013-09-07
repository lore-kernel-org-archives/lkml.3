Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab3IGOUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:20:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62034 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3IGOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:20:41 -0400
Message-ID: <522B3636.1000103@gmail.com>
Date: Sat, 07 Sep 2013 08:20:38 -0600
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
Subject: Re: [PATCH V2 2/2] perf kvm: fix sample_type manipulation
References: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com> <1378496412-2424-3-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1378496412-2424-3-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/13 1:40 PM, Adrian Hunter wrote:
> Manipulating the sample_type of an evsel requires
> the use of:
> 	perf_evsel__set_sample_bit()
> and	perf_evsel__reset_sample_bit()
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>


Tested-by and Acked-by David Ahern <dsahern@gmail.com>


