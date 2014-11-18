Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaKSO7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:59:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:46283 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbaKSO7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:59:12 -0500
Date: Tue, 18 Nov 2014 18:11:11 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: kan.liang@intel.com
Cc: jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V4 1/3] perf tool: Fix perf diff symble sort issue
Message-ID: <20141118211111.GC3790@kernel.org>
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
 <1416328700-1836-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416328700-1836-2-git-send-email-kan.liang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 18, 2014 at 11:38:18AM -0500, kan.liang@intel.com escreveu:
> From: Kan Liang <kan.liang@intel.com>
> 
> This patch fixes a bug for perf diff.
> Without mmap2, perf diff fails to find the symbol name. The default
> symbol sort key doesn't work well.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Applied, thanks.
