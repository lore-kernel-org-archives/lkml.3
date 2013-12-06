Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3LFSVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:21:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56653 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LFSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:21:37 -0500
Date: Fri, 6 Dec 2013 12:21:34 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: hexagon: include: uapi: asm: setup.h add swith
 macro __KERNEL__
Message-ID: <20131206182134.GC11490@codeaurora.org>
References: <528AEFB7.4060301@gmail.com>
 <20131125011938.GB18921@codeaurora.org>
 <5292B845.3010404@gmail.com>
 <5292B8A0.7020409@gmail.com>
 <5294255E.7040105@gmail.com>
 <52958304.4050707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52958304.4050707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 01:28:36PM +0800, Chen Gang wrote:
> Define dummy '__init' instead of include "linux/init.h" if !__KERNEL__,
> or can not pass checking. The related error (with allmodconfig under
> hexagon):
> 
>     CHECK   include/asm (34 files)
>   usr/include/asm/setup.h:22: included file 'linux/init.h' is not exported
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/include/uapi/asm/setup.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
