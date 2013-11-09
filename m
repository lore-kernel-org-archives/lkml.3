Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3KIQ62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:58:28 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63418 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3KIQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:58:26 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <527E69B1.20507@roeck-us.net>
Date: Sat, 09 Nov 2013 08:58:25 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/26] 3.4.69-stable review
References: <20131109065050.089866597@linuxfoundation.org>
In-Reply-To: <20131109065050.089866597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 10:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.69 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Nov 11 06:50:22 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.69-rc1.gz
> and the diffstat can be found below.
>

Build test results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all pass.

This matches the results from the previous release.

Thanks,
Guenter

