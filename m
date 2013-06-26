Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3FZU2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:28:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47673 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3FZU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:28:23 -0400
Date: Wed, 26 Jun 2013 13:28:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC/PATCH 11/11] ARM: msm: Move MSM's DT based hardware to
 multi-platform support
Message-ID: <20130626202821.GB11625@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
 <1371600281-6118-12-git-send-email-sboyd@codeaurora.org>
 <1372260541.6211.12.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372260541.6211.12.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Ivan T. Ivanov wrote:
> 
> You probably already know, but this patch causes compile error:
> 
> arch/arm/mach-msm/board-dt-8660.c:20:24: fatal error: mach/board.h: No such file or directory
> 
> I have fixed it locally like this:

Thanks. I think I'll just remove <mach/board.h> instead.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
