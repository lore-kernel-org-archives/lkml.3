Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3H3Fkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:40:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53730 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3H3Fkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:40:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5220254E.3050704@roeck-us.net>
Date: Thu, 29 Aug 2013 21:53:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com>
In-Reply-To: <52201896.9040309@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 08:59 PM, Chen Gang wrote:
> The related error (allmodconfig for h8300):
>
>    arch/h8300/kernel/setup.c: In function 'setup_arch':
>    arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared (first use in this function)
>       initrd_start = memory_start;
>       ^
>    arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier is reported only once for each function it appears in
>    arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared (first use in this function)
>       initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
>       ^
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---

Maybe an odd question, but is there a way to actually compile the h8300 target
in the first place ? The cross compiler on kernel.org doesn't work, nor does
the one available through Ubuntu.

Guenter

