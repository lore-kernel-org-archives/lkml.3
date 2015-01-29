Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbbA2Otl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:49:41 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46866 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbbA2Oti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:49:38 -0500
Message-ID: <54CA487D.4060906@suse.cz>
Date: Thu, 29 Jan 2015 15:49:33 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/176] 3.12.37-stable review
References: <cover.1422455352.git.jslaby@suse.cz> <20150128164830.GA27644@roeck-us.net>
In-Reply-To: <20150128164830.GA27644@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015, 05:48 PM, Guenter Roeck wrote:
> On Wed, Jan 28, 2015 at 03:29:35PM +0100, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.37 release.
>> There are 176 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri Jan 30 15:29:12 CET 2015.
>> Anything received after that time might be too late.
>>
> 
> Build results:
> 	total: 135 pass: 112 fail: 23
> Failed builds:
> 	arm:davinci_all_defconfig
> 	arm:vexpress_defconfig
> 	arm:imx_v4_v5_defconfig
> 	arm:lpc32xx_defconfig
> 	arm:orion5x_defconfig
> 	arm:msm_defconfig
> 	microblaze:mmu_defconfig
> 	microblaze:nommu_defconfig
> 	mips:cavium_octeon_defconfig
> 	openrisc:defconfig
> 	powerpc:allmodconfig
> 	powerpc:ppc64e_defconfig
> 	powerpc:ppc6xx_defconfig
> 	powerpc:mpc83xx_defconfig
> 	powerpc:mpc85xx_defconfig
> 	powerpc:mpc85xx_smp_defconfig
> 	powerpc:allmodconfig
> 	powerpc:ppc64e_defconfig
> 	powerpc:ppc6xx_defconfig
> 	powerpc:mpc83xx_defconfig
> 	powerpc:mpc85xx_defconfig
> 	powerpc:mpc85xx_smp_defconfig
> 	xtensa:allmodconfig
> 
> Qemu tests:
> 	total: 27 pass: 25 fail: 2
> Failed tests:
> 	arm:arm_vexpress_defconfig
> 	openrisc:openrisc_defconfig
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 
> ---
> Common error message:
> 
> drivers/gpio/gpiolib-of.c: In function ‘of_gpiochip_find_and_xlate’:
> drivers/gpio/gpiolib-of.c:50:3: error: implicit declaration of function ‘ERR_PTR’
>    gg_data->out_gpio = ERR_PTR(ret);
> 
> "#include <linux/err.h>" is missing in drivers/gpio/gpiolib-of.c.

I see... Now fixed hopefully. Thanks for letting me know.

-- 
js
suse labs
