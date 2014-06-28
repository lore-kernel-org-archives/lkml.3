Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaF1Wc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 18:32:57 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54252 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaF1Wc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 18:32:56 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AF4295.3010408@roeck-us.net>
Date: Sat, 28 Jun 2014 15:32:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.15 000/139] 3.15.3-stable review
References: <20140628174605.352098823@linuxfoundation.org>
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 10:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.3 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:45:39 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 136 skipped: 5 fail: 3
Failed builds:
	powerpc:allmodconfig
	powerpc:allmodconfig
	unicore32:defconfig

Qemu tests all passed.

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter

