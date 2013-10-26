Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3JZKC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 06:02:26 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37260 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3JZKCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 06:02:25 -0400
Date: Sat, 26 Oct 2013 12:02:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH 02/11] asmlinkage: Make __iowrite32_copy visible
Message-ID: <20131026100221.GG14237@gmail.com>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382458346-24811-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> This is a assembler function on x86, so it should be visible.
> 
> Cc: x86@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/io.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

NAK for this and all the other patches, for two technical reasons:

- Please squash most of these trivial patches into a single patch 
  that also describes the context completely, at least the x86 and 
  core kernel ones that I'd apply within a single maintenance 
  domain.

- Please use the customary changelog style we use in the kernel:

   " Current code does (A), this has a problem when (B).
     We can improve this doing (C), because (D)."

Just saying 'because of LTO' is not enough, obviously. You need to 
talk about and explain things Andi. Being cryptic, mysterious and 
curt might work with some ladies, but it's outright harmful on lkml.

Thanks,

	Ingo
