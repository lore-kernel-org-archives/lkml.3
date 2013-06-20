Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965750Ab3FTSyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:54:24 -0400
Received: from relais.videotron.ca ([24.201.245.36]:22338 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965649Ab3FTSyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:54:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 20 Jun 2013 14:54:21 -0400 (EDT)
From: Nicolas Pitre <nico@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cov@codeaurora.org, marc.zyngier@arm.com
Subject: Re: [PATCH v2 0/2] ARM: Remove any correlation between IPC and
 BogoMips value
In-reply-to: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
Message-id: <alpine.LFD.2.03.1306201452330.18597@syhkavp.arg>
References: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Will Deacon wrote:

> Hi all,
> 
> This is version two of the patches I originally posted here:
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166728.html
> 
> Comments received there largely confirmed that it's not possible to choose
> an `obviously bogus' value for BogoMIPs, so instead I've bitten the bullet
> and removed the line altogether.
> 
> In the meantime, I've only had one complaint this month about BogoMIPs
> being wrong, so perhaps the initial posting served some purpose without
> even being merged!
> 
> Comments welcome,

Enthusiastic ACK for both patches.


Nicolas
