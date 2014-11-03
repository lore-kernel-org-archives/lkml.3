Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaKCNyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:54:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaKCNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:54:35 -0500
Date: Mon, 3 Nov 2014 14:54:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf tools: Add gzip decompression support for
 kernel module
Message-ID: <20141103135418.GD29906@krava.brq.redhat.com>
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
 <1414999678-31377-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414999678-31377-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:27:52PM +0900, Namhyung Kim wrote:

SNIP

>   #
>   # Overhead  Command          Shared Object                Symbol
>   # ........  ...............  ...........................  ......................................................
>   #
> 
>        0.04%  kworker/u16:3    [ext4]                       [k] ext4_read_block_bitmap
>        0.03%  kworker/u16:0    [mac80211]                   [k] ieee80211_sta_reset_beacon_monitor
>        0.02%  irq/50-iwlwifi   [mac80211]                   [k] ieee80211_get_bssid
>        0.02%  firefox          [e1000e]                     [k] __ew32_prepare
>        0.02%  swapper          [libahci]                    [k] ahci_handle_port_interrupt
>        0.02%  emacs            libglib-2.0.so.0.4000.0      [.] g_mutex_unlock
>        0.02%  swapper          [e1000e]                     [k] e1000_clean_tx_irq
>        0.02%  dwm              [kernel.kallsyms]            [k] __schedule
>        0.02%  gnome-terminal-  [vdso]                       [.] __vdso_clock_gettime
>        0.02%  swapper          [e1000e]                     [k] e1000_alloc_rx_buffers
>        0.02%  irq/50-iwlwifi   [mac80211]                   [k] ieee80211_rx
>        0.01%  firefox          [vdso]                       [.] __vdso_gettimeofday
>        0.01%  irq/50-iwlwifi   [iwlwifi]                    [k] iwl_pcie_rxq_restock.part.13
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Makefile.perf                     |  7 +++
>  tools/perf/config/Makefile                   | 15 +++++-
>  tools/perf/config/feature-checks/Makefile    |  6 ++-
>  tools/perf/config/feature-checks/test-zlib.c |  9 ++++

missing update for feature-checks/test-all.c

thanks,
jirka
