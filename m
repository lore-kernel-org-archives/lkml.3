Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3H0Ebj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:31:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63072 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3H0Ebi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:31:38 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521C2BA7.2010705@roeck-us.net>
Date: Mon, 26 Aug 2013 21:31:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/74] 3.10.10-stable review
References: <20130827010424.535365435@linuxfoundation.org>
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 06:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.10 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 29 01:03:56 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.10-rc1.gz
> and the diffstat can be found below.
>

Cross build results:
	total: 85 pass: 85 fail: 0
Compared to 3.10.8:
	total: 76 pass: 76 fail: 0

qemu tests:
	arm, microblaze, mips, mips64, ppc, x86, x86_64: pass (boot to login prompt)
	
Note that the arm qemu test now passes because I found a workaround for the bug
causing the failure observed with the previous release, not because the bug was fixed.

More builds, more platforms tested, still no failures. Results look good.

Details:
	http://server.roeck-us.net:8010/builders

Guenter


