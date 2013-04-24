Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab3DXKwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:52:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34507 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab3DXKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:52:09 -0400
X-Spam-Score: -100.8
Message-ID: <5177B92A.5030004@asianux.com>
Date: Wed, 24 Apr 2013 18:51:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: compiling issue, need add include/asm/vga.h
 file
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com> <5177B1F0.10106@asianux.com> <20130424104231.GJ23397@arm.com>
In-Reply-To: <20130424104231.GJ23397@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月24日 18:42, Catalin Marinas wrote:
> On Wed, Apr 24, 2013 at 11:20:32AM +0100, Chen Gang wrote:
>> For compiling with allmodconfig, need vga.h file, so generate it which
>> just only include the asm-generic one.
>>
>> It is firstly used by drivers/gpu/drm/drm_irq.c.
>>
>> The related error:
>> include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/arm64/include/asm/vga.h |   21 +++++++++++++++++++++
>>  1 files changed, 21 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/vga.h
> 
> As Will said, please use asm/Kbuild.
> 

OK, I will send.

>> diff --git a/arch/arm64/include/asm/vga.h b/arch/arm64/include/asm/vga.h
>> new file mode 100644
>> index 0000000..1c49d51
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/vga.h
>> @@ -0,0 +1,21 @@
>> +/*
>> + * Copyright (C) 2012 ARM Ltd.
> 
> ARM copyright? You either work for ARM or there is a copyright
> assignment between you and ARM ;)
> 

:-)

-- 
Chen Gang

Asianux Corporation
