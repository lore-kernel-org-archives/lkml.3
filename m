Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaF1W2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 18:28:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63730 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaF1W2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 18:28:45 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AF419A.20202@roeck-us.net>
Date: Sat, 28 Jun 2014 15:28:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/43] 3.4.96-stable review
References: <20140628174449.788784511@linuxfoundation.org>
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 10:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.96 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:44:34 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 137 pass: 111 skipped: 20 fail: 6
Failed builds:
	alpha:allmodconfig
	arm:spear6xx_defconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter

