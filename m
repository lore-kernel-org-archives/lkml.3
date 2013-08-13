Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3HMLtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:49:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54848 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3HMLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:49:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520A1D56.2050507@roeck-us.net>
Date: Tue, 13 Aug 2013 04:49:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.4.58-stable review
References: <20130813063501.728847844@linuxfoundation.org>
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.58 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 15 06:34:52 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.58-rc1.gz
> and the diffstat can be found below.
>
Cross build results:
	Total builds: 62 Total build errors: 10

qemu:
	mips, ppc, x86, x86_64 pass (boot to login prompt)

Details:
	http://server.roeck-us.net:8010/waterfall

Everything as expected.

Guenter

