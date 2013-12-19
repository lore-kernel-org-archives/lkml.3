Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3LSCHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:07:09 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63337 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3LSCHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:07:06 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52B254C9.1030805@roeck-us.net>
Date: Wed, 18 Dec 2013 18:07:05 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
References: <20131218211219.461663463@linuxfoundation.org>
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 01:10 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.6 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> Anything received after that time might be too late.
>

Build results:
     total: 110 pass: 96 skipped: 3 fail: 11

qemu tests all passed.

Build failure log:

drivers/staging/comedi/drivers/ssv_dnp.c: In function 'dnp_dio_insn_bits':
drivers/staging/comedi/drivers/ssv_dnp.c:63:2: error: implicit declaration of function 'comedi_dio_update_state' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [drivers/staging/comedi/drivers/ssv_dnp.o] Error 1

due to the two patches I mentioned earlier.

Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter


