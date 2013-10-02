Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3JBREo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:04:44 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54055 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754351Ab3JBREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:04:42 -0400
Date: Wed, 2 Oct 2013 18:03:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Remove duplicate DEBUG_STACK_USAGE config
Message-ID: <20131002170349.GF29794@arm.com>
References: <1380660523-19036-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380660523-19036-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 09:48:43PM +0100, Stephen Boyd wrote:
> This config item already exists generically in lib/Kconfig.debug.
> Remove the duplicate config in arm64.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks. Applied.

-- 
Catalin
