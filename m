Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3LMP7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:59:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64963 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584Ab3LMP7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:59:09 -0500
Date: Fri, 13 Dec 2013 15:58:40 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/7] arm64: introduce
 aarch64_insn_gen_{nop|branch_imm}() helper functions
Message-ID: <20131213155840.GJ19177@mudshark.cambridge.arm.com>
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
 <1386691433-6827-5-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386691433-6827-5-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:03:50PM +0000, Jiang Liu wrote:
> Introduce aarch64_insn_gen_{nop|branch_imm}() helper functions, which
> will be used to implement jump label on ARM64.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Looks good to me:

  Reviewed-by: Will Deacon <will.deacon@arm.com>

Thanks!

Will
