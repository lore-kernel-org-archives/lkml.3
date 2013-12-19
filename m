Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3LSNcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3LSNcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:32:13 -0500
Date: Thu, 19 Dec 2013 14:31:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/6] perf report: Use pr_*() functions if possible
Message-ID: <20131219133154.GB3568@krava.brq.redhat.com>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
 <1387436411-20160-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387436411-20160-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:00:06PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There're some places printing a message to stdout/err directly.  It
> should be converted to use proper error printing functions instead.
> 
> If it's not possible, just do it when --stdio was enabled only.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Maybe it'd be worthwhile to factor perf_session__fprintf*
functions so the info could end up in the log window.

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
