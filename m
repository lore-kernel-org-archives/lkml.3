Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3LQSMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:12:50 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:58334 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754991Ab3LQSMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:12:48 -0500
Date: Tue, 17 Dec 2013 18:12:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM64: check stack pointer in get_wchan
Message-ID: <20131217181228.GT32118@arm.com>
References: <20131205133010.16410.96824.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205133010.16410.96824.stgit@buzz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 01:30:10PM +0000, Konstantin Khlebnikov wrote:
> get_wchan() is lockless. Task may wakeup at any time and change its own stack,
> thus each next stack frame may be overwritten and filled with random stuff.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

Thanks. Applied (both patches).

-- 
Catalin
