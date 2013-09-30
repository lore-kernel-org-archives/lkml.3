Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3I3BY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:24:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63632 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3I3BY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:24:57 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5248D2E4.10206@roeck-us.net>
Date: Sun, 29 Sep 2013 18:24:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.98-stable review
References: <20130929190757.138351117@linuxfoundation.org>
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.98 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:07:47 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.98-rc1.gz
> and the diffstat can be found below.
>


Build test results:
	total: 98 pass: 71 skipped: 16 fail: 11

qemu:
	ppc, sh, sparc, x86, x86_64 passed
	arm, microblaze, mips, mips64, sparc64 skipped

Same results as with 3.0.97.

Guenter

