Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3JaSlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:41:09 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51179 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754Ab3JaSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:41:07 -0400
Date: Thu, 31 Oct 2013 17:39:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Will Deacon <Will.Deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/7] arm64: introduce basic aarch64 instruction
 decoding helpers
Message-ID: <20131031173946.GL26009@arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-2-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382109602-27432-2-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:19:55PM +0100, Jiang Liu wrote:
> +/*
> + * ARMv8-A Section B2.6.5:

Minor comment - please specify the document revision and the title of
the section as they keep changing in subsequent ARMv8 ARM updates and
this comment would no longer match.

-- 
Catalin
