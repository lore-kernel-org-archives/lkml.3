Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030535Ab3DSMc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:32:27 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56394 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030490Ab3DSMc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:32:26 -0400
Date: Fri, 19 Apr 2013 13:31:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue, duplicate definition
 of early_console
Message-ID: <20130419123150.GA18443@arm.com>
References: <5152DB83.8080703@asianux.com>
 <20130327115509.GA1603@MacBook-Pro.local>
 <5152DFF1.2090000@asianux.com>
 <515BE49C.8040601@asianux.com>
 <515C14FD.4040703@codeaurora.org>
 <515C2808.70406@asianux.com>
 <516E66F9.9070904@asianux.com>
 <51712213.4060607@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51712213.4060607@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 11:53:07AM +0100, Chen Gang wrote:
>   when compiling with allmodconfig.
>     early_console is already defined as an extern global pointer.
> 
>   need let it point to the object which we intend to (like ARM32 done).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Thanks for the patch.

-- 
Catalin
