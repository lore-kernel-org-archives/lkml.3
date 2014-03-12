Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaCLXB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:01:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57764 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaCLXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:01:57 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5320E763.9020901@roeck-us.net>
Date: Wed, 12 Mar 2014 16:01:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
CC: Paul Burton <paul.burton@imgtec.com>, Paul Bolle <pebolle@tiscali.nl>,
        Huacai Chen <chenhc@lemote.com>, Andreas Barth <aba@ayous.org>
Subject: Re: [PATCH RESEND 1/2] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
References: <1394664067-17712-1-git-send-email-aaro.koskinen@iki.fi> <1394664067-17712-2-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1394664067-17712-2-git-send-email-aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 03:41 PM, Aaro Koskinen wrote:
> From: Paul Bolle <pebolle@tiscali.nl>
>
> Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
> introduced references to two undefined Kconfig macros. CONFIG_MIPS32_R2
> should clearly be replaced with CONFIG_CPU_MIPS32_R2. And CONFIG_MIPS64
> should apparently be replaced with CONFIG_64BIT.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

With qemu-system-mips64:

Tested-by: Guenter Roeck <linux@roeck-us.net>

