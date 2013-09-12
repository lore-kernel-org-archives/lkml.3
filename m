Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3ILWfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:35:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60770 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3ILWfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:35:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5232419D.1020403@roeck-us.net>
Date: Thu, 12 Sep 2013 15:35:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/46] 3.10.12-stable review
References: <20130912175721.001906199@linuxfoundation.org>
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.12 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 14 17:56:26 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.12-rc1.gz
> and the diffstat can be found below.
>

Build results:
	total: 110 pass: 110 skipped: 0 fail: 0

Added cris32 and several arm targets since last time. Still no failures.

qemu:
	arm, microblaze, mips, mips64, ppc, x86, x86_64 all pass.
	sh passed with warning.

qemu:sh is new and only passes because of a patch I had to add to fix qemu,
so don't try it yourself. It also does create a backtrace due to a known
problem for which a patch has been submitted but is not yet available
upstream.

Details are at http://server.roeck-us.net:8010/builders.

Guenter

