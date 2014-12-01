Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbaLAWfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:35:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:45011 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbaLAWfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:35:47 -0500
Date: Mon, 1 Dec 2014 19:35:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: kan.liang@intel.com
Cc: jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V5 1/1] perf tool:perf diff support for different binaries
Message-ID: <20141201223541.GM30226@kernel.org>
References: <1416585348-14762-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416585348-14762-1-git-send-email-kan.liang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 21, 2014 at 10:55:48AM -0500, kan.liang@intel.com escreveu:
> From: Kan Liang <kan.liang@intel.com>
> 
> Currently, the perf diff only works with same binaries. That's because
> it compares the symbol start address. It doesn't work if the perf.data
> comes from different binaries. This patch matches the function names.
> 
> Here is a simple examples (Only change f2 and f3 functions location.)
> There is no change in behavior, but the old perf diff display the wrong
> differential profile.

[acme@zoo linux]$ am /wb/1.patch 
Applying: perf tool:perf diff support for different binaries
/home/acme/git/linux/.git/rebase-apply/patch:23: trailing whitespace.
If no parameters are passed the samples will be sorted by dso and
symbol. 
/home/acme/git/linux/.git/rebase-apply/patch:26: trailing whitespace.
symbols name. 
warning: 2 lines add whitespace errors.

[1]+  Stopped                 am /wb/1.patch
[acme@zoo linux]$

Fixing this up this time.

Please consider:

chmod +x .git/hooks/*

- Arnaldo
