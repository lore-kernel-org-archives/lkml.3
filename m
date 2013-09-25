Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3IYTpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:45:23 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:44324 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751242Ab3IYTpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:45:22 -0400
Date: Wed, 25 Sep 2013 15:46:58 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Jiri Olsa <jolsa@redhat.com>
cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/21] perf: Add event toggle ioctl interface
In-Reply-To: <1380113447-17144-7-git-send-email-jolsa@redhat.com>
Message-ID: <alpine.DEB.2.02.1309251545440.21782@pianoman.cluster.toy>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com> <1380113447-17144-7-git-send-email-jolsa@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.52433D51.0114,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Jiri Olsa wrote:

> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -325,6 +325,7 @@ struct perf_event_attr {
>  #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
>  #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
>  #define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
> +#define PERF_EVENT_IOC_SET_TOGGLE	_IOW('$', 8, u64 *)

I'm pretty sure this should be __u64 or else it won't compile
in userspace.

Vince
