Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaJXHrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:47:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49536 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaJXHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:47:37 -0400
Date: Fri, 24 Oct 2014 09:47:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20141024074732.GA22517@gmail.com>
References: <1414012017-26261-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414012017-26261-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 3b10ea7f922b538ba5dcb3d979a6b6b4d07daae2:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-10-18 09:04:02 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 9ab1f50876dbb8b962db058259be7aae920d4c25:
> 
>   perf diff: Add missing hists__init() call at tool start (2014-10-22 16:31:06 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fix:
> 
> * Fix 'perf diff' initialization, calling the recently added hists__init()
>   function so that extra space is allocated per perf_evsel for the hists storage
>   that it also uses, just like report and top.  (Kan Liang)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Kan Liang (1):
>       perf diff: Add missing hists__init() call at tool start
> 
>  tools/perf/builtin-diff.c | 5 +++++
>  1 file changed, 5 insertions(+)

Pulled, thanks a lot Arnaldo!

	Ingo
