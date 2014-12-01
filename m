Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaLAURq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:17:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbaLAURp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:17:45 -0500
Date: Mon, 1 Dec 2014 21:17:38 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V5 1/1] perf tool:perf diff support for different binaries
Message-ID: <20141201201737.GB13302@krava.brq.redhat.com>
References: <1416585348-14762-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416585348-14762-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:55:48AM -0500, kan.liang@intel.com wrote:

SNIP

>      0.00%           [kernel.vmlinux]  [k] native_read_tsc
>      0.00%           [kernel.vmlinux]  [k] native_write_msr_safe
>                      [kernel.vmlinux]  [k] ntp_tick_length
>      0.00%           [kernel.vmlinux]  [k] rb_erase
>      0.00%           [kernel.vmlinux]  [k] tick_sched_timer
>      0.00%           [kernel.vmlinux]  [k] unmap_single_vma
>      0.00%           [kernel.vmlinux]  [k] update_wall_time
>      0.00%           example           [.] f1
>     46.24%   -0.08%  example           [.] f2
>     53.71%   +0.11%  example           [.] f3
>      0.02%           example           [.] main
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
