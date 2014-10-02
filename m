Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaJBPwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:52:33 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40663 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaJBPwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:52:32 -0400
Date: Thu, 2 Oct 2014 16:52:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCHv3 00/24] ILP32 support in ARM64
Message-ID: <20141002155217.GH32147@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:18:54PM +0100, Andrew Pinski wrote:
> New version with all of the requested changes.  Updated to the latest sources.
> 
> Notable changes from the previous versions:
> VDSO code has been factored out to be easier to understand and easier to maintain.
> Move the config option to the last thing that gets added.
> Added some extra COMPAT_* macros for core dumping for easier usage.

Apart from a few comments I've made, I would also like to see non-empty
commit logs and long line wrapping (both in commit logs and
Documentation/). Otherwise, the patches look fine.

So what are the next steps? Are the glibc folk ok with the ILP32 Linux
ABI? On the kernel side, what I would like to see:

1. LTP results (in all combinations of AArch32, LP64, ILP32, big and
   little endian)
2. A way for us to reproduce the ILP32 tests - at which point could we
   get a toolchain? Ideally a filesystem as well, though maybe we could
   just use a busybox in the meantime.

Thanks.

-- 
Catalin
