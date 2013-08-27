Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3H0EWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:22:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62589 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3H0EWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:22:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521C2991.1070504@roeck-us.net>
Date: Mon, 26 Aug 2013 21:22:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/13] 3.4.60-stable review
References: <20130827010309.850395966@linuxfoundation.org>
In-Reply-To: <20130827010309.850395966@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 06:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.60 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 29 01:03:03 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.60-rc1.gz
> and the diffstat can be found below.
>

Cross build results:
	total: 75 pass: 73 fail: 2
Compared to 3.4.59:
	total: 69 pass: 67 fail: 2

qemu tests:
	mips, mips64, ppc, x86, x86_64: pass (boot to login prompt)
	arm: skipped

More builds, more platforms tested, still only two failures. Results look good.

Details:
	http://server.roeck-us.net:8010/builders

Guenter

