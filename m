Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3LRPlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3LRPlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:41:08 -0500
Date: Wed, 18 Dec 2013 16:40:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 02/18] perf sort: Do not compare dso again
Message-ID: <20131218154043.GG4146@krava.brq.redhat.com>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
 <1387344086-12744-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387344086-12744-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:21:10PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The commit 09600e0f9ebb ("perf tools: Compare dso's also when
> comparing symbols") added a comparison of dso when comparing symbol.
> But if the sort key already has dso, it doesn't need to do it again
> since entries have a different dso already filtered out.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
