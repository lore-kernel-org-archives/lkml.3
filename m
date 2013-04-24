Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3DXIpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:45:42 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63705 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3DXIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:45:40 -0400
X-Spam-Score: -100.8
Message-ID: <51779B86.4030306@asianux.com>
Date: Wed, 24 Apr 2013 16:44:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: compiling issue, need add include/asm/vga.h file
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com>
In-Reply-To: <20130424082237.GA23397@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月24日 16:22, Catalin Marinas wrote:
> On Wed, Apr 24, 2013 at 04:44:29AM +0100, Chen Gang wrote:
>> For compiling with allmodconfig, need vga.h file, so copy it from arm32.
> 
> I would rather use the generic vga.h. We don't even have a vga_base
> defined.
> 

OK, thanks. I need send patch v2.

-- 
Chen Gang

Asianux Corporation
