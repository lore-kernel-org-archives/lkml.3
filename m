Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaIIMkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:40:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42338 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbaIIMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:40:07 -0400
Date: Tue, 9 Sep 2014 13:39:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: add guard macro of unistd.h to prevent double
 inclusion
Message-ID: <20140909123938.GL1754@arm.com>
References: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 04:59:45AM +0100, Yang Yingliang wrote:
> Add guard macros in both uapi/asm/unistd.h and asm/unistd.h.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  arch/arm64/include/asm/unistd.h      | 5 +++++
>  arch/arm64/include/uapi/asm/unistd.h | 5 +++++
>  2 files changed, 10 insertions(+)

We probably need something similar for unistd32.h too, as lib/compat_audit.c
now includes that.

Can you post a v2 please?

Will
