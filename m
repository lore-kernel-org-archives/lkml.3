Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3DXLFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:05:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:55532 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756477Ab3DXLFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:05:32 -0400
Date: Wed, 24 Apr 2013 12:05:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arm64: compiling issue, need add include/asm/vga.h
 file
Message-ID: <20130424110511.GK23397@arm.com>
References: <5177551D.8090007@asianux.com>
 <20130424082237.GA23397@arm.com>
 <5177B1F0.10106@asianux.com>
 <20130424102327.GF21850@mudshark.cambridge.arm.com>
 <5177BAD0.9000500@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177BAD0.9000500@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:58:24AM +0100, Chen Gang wrote:
> 
> For compiling with allmodconfig, need vga.h file, so generate it which
> just only include the asm-generic one.
> 
> It is firstly used by drivers/gpu/drm/drm_irq.c.
> 
> The related error:
> include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Looks fine. Thanks.

-- 
Catalin
