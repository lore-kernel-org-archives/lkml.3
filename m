Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbaEPQow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:44:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53688 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752576AbaEPQov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:44:51 -0400
Date: Fri, 16 May 2014 17:44:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v3] arm64: Support arch_irq_work_raise() via self IPIs
Message-ID: <20140516164402.GK5624@arm.com>
References: <1399909731-21196-1-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399909731-21196-1-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:48:51PM +0100, Larry Bassel wrote:
> Support for arch_irq_work_raise() was missing from
> arm64 (a prerequisite for FULL_NOHZ).
> 
> This patch is based on the arm32 patches ARM 7872/1
> and 7887/1.

Applied (with some clean-up of the commit log). Thanks.

-- 
Catalin
