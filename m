Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3I3Oyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:54:31 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53038 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754797Ab3I3Oy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:54:29 -0400
Date: Mon, 30 Sep 2013 15:54:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH 0/2] Lower entry barrier for arm64 development
Message-ID: <20130930145404.GC22046@arm.com>
References: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:19:54PM +0100, Ramkumar Ramachandra wrote:
> So I got this far after many hours of scratching my head. Let's make
> EXT4, VIRTIO_MMIO, and VIRTIO_BLK part of the default configuration so
> users have a pleasant ride when attempting to run their freshly built
> AArch64 kernel. My boot wrapper has diverged from Catalin's quite
> significantly [1], and it works well for me. I intend to address more
> papercuts in future patches.
> 
> Thanks.
> 
> [1]: https://github.com/artagnon/boot-wrapper-aarch64
> 
> Ramkumar Ramachandra (2):
>   arm64: include EXT4 in defconfig
>   arm64: include VIRTIO_{MMIO,BLK} in defconfig

Thanks. Both patches applied.

-- 
Catalin
