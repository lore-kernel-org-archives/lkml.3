Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3DWKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:49:26 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51068 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204Ab3DWKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:49:25 -0400
Date: Tue, 23 Apr 2013 11:48:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue, define cmpxchg64 and
 cmpxchg64_local for outside using.
Message-ID: <20130423104851.GC23407@arm.com>
References: <51712E5E.2020809@asianux.com>
 <201304191412.54601.arnd@arndb.de>
 <5171FD67.2080104@asianux.com>
 <2182812.ymprEm6XBb@wuerfel>
 <5174C5D9.3060109@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5174C5D9.3060109@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 06:08:41AM +0100, Chen Gang wrote:
> 
>   drivers use cmpxchg64, cmpxchg64_local ... to perform 64-bit operation,
>   so they can cross 32-bit and 64-bit platforms (it is a standard way).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied, thanks.

-- 
Catalin
