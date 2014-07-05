Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaGEHop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 03:44:45 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49596 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaGEHoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 03:44:44 -0400
Date: Sat, 5 Jul 2014 09:44:40 +0200
From: Andreas Mohr <andi@lisas.de>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-ID: <20140705074440.GA9774@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B667F9.90306@bull.net>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

two typos:

> +config BH_LRU_SIZE
> +      int "buffer head per-CPU LRU size"
> +      range 8 64
> +      default "16"
> +      help
> +        This sets the per-CPU LRU size for buffer heads in memory.
> +        More complex filesystems may be modiyfing multiple blocks
                                           ^^^^^^^

> +        within a single transaction, so keeping the buffer heads in
> +        CPU-local cache speeds up modifations significantly.
                                        ^^^^^^

Thanks for this nice optimization,

Andreas Mohr
