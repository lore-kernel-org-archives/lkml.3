Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaD2Joa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:44:30 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43735 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933000AbaD2Jo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:44:27 -0400
Date: Tue, 29 Apr 2014 10:43:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH 3/3] arm64: enable context tracking
Message-ID: <20140429094353.GD17007@arm.com>
References: <1398627854-9617-1-git-send-email-larry.bassel@linaro.org>
 <1398627854-9617-4-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398627854-9617-4-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 08:44:14PM +0100, Larry Bassel wrote:
> Make calls to ct_user_enter when the kernel is exited
> and ct_user_exit when the kernel is entered (in el0_da,
> el0_ia, el0_svc, el0_irq).
> 
> These macros expand to function calls which will only work
> properly if el0_sync and related code has been rearranged
> (in a previous patch of this series).
> 
> The calls to ct_user_exit are made after hw debugging has been
> enabled (enable_dbg).
> 
> The call to ct_user_enter is made at the end of the kernel_exit
> macro.
> 
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Larry Bassel <larry.bassel@linaro.org>

You could actually merge this patch with 2/3.

-- 
Catalin
