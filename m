Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaHYRAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbaHYRAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:00:12 -0400
Date: Mon, 25 Aug 2014 12:59:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kexec: minor fixups and enhancements
Message-ID: <20140825165916.GC14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408731991.git.geoff@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:39:47PM +0000, Geoff Levand wrote:
> Hi,
> 
> Here are a few minor fixups and enhancements for kexec support. 
> 
> Patch 3 and 4 that add preprocessor macros for the kimage list flags are
> ones that I use in the arm64 kexec support I am working on, so it would
> be nice for those to go in.
> 
> Please consider.

Hi Geoff,

Does arm64 has secureboot? If yes, then it might make sense to
enable the new syscall kexec_file_load() on arm64 instead of trying
to make old syscall work first.

Thanks
Vivek

> 
> -Geoff
>     
> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
> 
>   Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/geoff.levand/linux-kexec.git for-kexec
> 
> for you to fetch changes up to dc3c63e69815e00dce5454bd50e2991e9ea33f64:
> 
>   powerpc/kexec: Use global IND_FLAGS macro (2014-08-22 11:15:18 -0700)
> 
> ----------------------------------------------------------------
> Geoff Levand (5):
>       kexec: Fix make headers_check
>       kexec: Simplify conditional
>       kexec: Add bit definitions for kimage entry flags
>       kexec: Add IND_FLAGS macro
>       powerpc/kexec: Use global IND_FLAGS macro
> 
>  arch/powerpc/kernel/machine_kexec_64.c |  2 --
>  include/linux/kexec.h                  | 20 ++++++++++++++++----
>  include/uapi/linux/kexec.h             |  6 ------
>  kernel/kexec.c                         | 17 ++++++++++-------
>  4 files changed, 26 insertions(+), 19 deletions(-)
> 
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
