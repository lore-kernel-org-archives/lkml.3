Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbaCTRmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:42:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45805 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756155AbaCTRmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:42:50 -0400
Date: Thu, 20 Mar 2014 17:42:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Alexander Kartashov <alekskartashov@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: Fix __range_ok macro
Message-ID: <20140320174217.GB28238@arm.com>
References: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
 <1395246577-22120-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395246577-22120-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 04:29:37PM +0000, Christopher Covington wrote:
> Without this, the following scenario is incorrectly determined
> to be invalid.
> 
> addr 0x7f_ffffe000 size 8192 addr_limit 0x80_00000000
> 
> This behavior was observed while trying to vmsplice the stack
> as part of a CRIU dump of a process on a system started with the
> norandmaps kernel parameter.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>

Thanks, applied.

-- 
Catalin
