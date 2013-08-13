Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3HML5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:57:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51413 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3HML5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:57:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520A1F15.7010209@roeck-us.net>
Date: Tue, 13 Aug 2013 04:57:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/60] 3.10.7-stable review
References: <20130813063331.950321483@linuxfoundation.org>
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:33 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.7 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 15 06:33:14 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.7-rc1.gz
> and the diffstat can be found below.
>
Cross build results:
	Total builds: 69 Total build errors: 0

qemu:
	mips, ppc, x86, x86_64 pass (boot to login prompt)
	arm: fail (known problem, see https://lkml.org/lkml/2013/8/11/41)

Details:
	http://server.roeck-us.net:8010/waterfall

Builds failing on 3.10.6 (mips:allmodconfig and arm:allmodconfig) now pass,
so results are better than with the previous release.

Guenter

