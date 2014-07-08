Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaGHNOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:14:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58502 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaGHNOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:14:08 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BBEE9D.4020900@roeck-us.net>
Date: Tue, 08 Jul 2014 06:14:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/44] 3.4.98-stable review
References: <20140707235858.652771077@linuxfoundation.org>
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 05:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.98 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  9 23:58:50 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 117 pass: 111 fail: 6
Failed builds:
	alpha:allmodconfig
	arm:spear6xx_defconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Note that git describe says v3.4.97-46, so the tested version includes
two more patches than announced.

Guenter

