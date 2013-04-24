Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3DXIXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:23:06 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43810 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757838Ab3DXIXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:23:04 -0400
Date: Wed, 24 Apr 2013 09:22:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: compiling issue, need add include/asm/vga.h file
Message-ID: <20130424082237.GA23397@arm.com>
References: <5177551D.8090007@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177551D.8090007@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:44:29AM +0100, Chen Gang wrote:
> For compiling with allmodconfig, need vga.h file, so copy it from arm32.

I would rather use the generic vga.h. We don't even have a vga_base
defined.

-- 
Catalin
