Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3DXLGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:06:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14875 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3DXLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:06:49 -0400
X-Spam-Score: -100.8
Message-ID: <5177BC9B.1060103@asianux.com>
Date: Wed, 24 Apr 2013 19:06:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arm64: compiling issue, need add include/asm/vga.h
 file
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com> <5177B1F0.10106@asianux.com> <20130424102327.GF21850@mudshark.cambridge.arm.com> <5177BAD0.9000500@asianux.com> <20130424110511.GK23397@arm.com>
In-Reply-To: <20130424110511.GK23397@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月24日 19:05, Catalin Marinas wrote:
> On Wed, Apr 24, 2013 at 11:58:24AM +0100, Chen Gang wrote:
>> > 
>> > For compiling with allmodconfig, need vga.h file, so generate it which
>> > just only include the asm-generic one.
>> > 
>> > It is firstly used by drivers/gpu/drm/drm_irq.c.
>> > 
>> > The related error:
>> > include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Looks fine. Thanks.

Thanks, too.

-- 
Chen Gang

Asianux Corporation
