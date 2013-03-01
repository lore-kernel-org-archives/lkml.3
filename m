Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3CAAhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:37:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3CAAho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:37:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,758,1355068800"; 
   d="scan'208";a="6789861"
Subject: Re: [PATCH 1/3] perf: sort command-list.txt by alphabet order
From: li guang <lig.fnst@cn.fujitsu.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Fri, 01 Mar 2013 08:37:21 +0800
Message-ID: <1362098241.2262.48.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 08:36:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 08:36:48,
	Serialize complete at 2013/03/01 08:36:48
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ...

在 2013-02-26二的 12:12 +0800，liguang写道：
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  tools/perf/command-list.txt |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
> index 3e86bbd..a28e31b 100644
> --- a/tools/perf/command-list.txt
> +++ b/tools/perf/command-list.txt
> @@ -10,17 +10,17 @@ perf-buildid-list		mainporcelain common
>  perf-diff			mainporcelain common
>  perf-evlist			mainporcelain common
>  perf-inject			mainporcelain common
> +perf-kmem			mainporcelain common
> +perf-kvm			mainporcelain common
>  perf-list			mainporcelain common
> -perf-sched			mainporcelain common
> +perf-lock			mainporcelain common
> +perf-probe			mainporcelain full
>  perf-record			mainporcelain common
>  perf-report			mainporcelain common
> +perf-sched			mainporcelain common
> +perf-script			mainporcelain common
>  perf-stat			mainporcelain common
> +perf-test			mainporcelain common
>  perf-timechart			mainporcelain common
>  perf-top			mainporcelain common
>  perf-trace			mainporcelain common
> -perf-script			mainporcelain common
> -perf-probe			mainporcelain full
> -perf-kmem			mainporcelain common
> -perf-lock			mainporcelain common
> -perf-kvm			mainporcelain common
> -perf-test			mainporcelain common


