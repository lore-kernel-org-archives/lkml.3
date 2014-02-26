Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaBZSF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:05:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48207 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaBZSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:05:28 -0500
Date: Wed, 26 Feb 2014 12:05:24 -0600
From: rkuo <rkuo@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, paulus@samba.org
Subject: Re: [PATCH 2/2] asm-generic: rwsem: de-PPCify rwsem.h
Message-ID: <20140226180524.GA11268@codeaurora.org>
References: <1393003347-24958-1-git-send-email-will.deacon@arm.com>
 <1393003347-24958-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393003347-24958-2-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:22:27PM +0000, Will Deacon wrote:
> asm-generic/rwsem.h used to live under arch/powerpc. During its
> liberation to common code, a few references to its former home where
> preserved, in particular the definition of RWSEM_ACTIVE_MASK is
> predicated on CONFIG_PPC64.
> 
> This patch updates the ifdefs and comments to architecturally neutral
> versions.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/asm-generic/rwsem.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 

Thanks; I probably should have noticed these when I copied the file over.

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
