Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbbALQsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:48:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:36064 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbbALQsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:48:04 -0500
Date: Mon, 12 Jan 2015 13:40:31 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Kan Liang <kan.liang@intel.com>
Subject: Re: [PATCHSET 0/7] perf diff: Fix and improve output ordering (v2)
Message-ID: <20150112164031.GB29743@kernel.org>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 08, 2015 at 09:45:41AM +0900, Namhyung Kim escreveu:
> Hello,
> 
> This patchset improves perf diff output to sort by baseline and then
> next columns in turn.  And fix -o/--order option behavior too.
> 
>  * changes in v2)
>   - pass fmt arg to ->cmp, ->collapse, ->sort callbacks (Jiri)
>   - add Acked-by from Jiri
> 
> The patch 1-3 are resend.  The patch 4-5 are preparation and the patch
> 6-7 are the main change.

Applied to perf/core.

- Arnaldo
