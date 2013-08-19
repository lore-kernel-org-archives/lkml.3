Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3HSBtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:49:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53580 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3HSBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:49:12 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52117995.7030405@roeck-us.net>
Date: Sun, 18 Aug 2013 18:49:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/34] 3.4.59-stable review
References: <20130818203259.653403173@linuxfoundation.org>
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 01:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.59 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Note, there are a number of "build fixes" in this round, in the quest to
> get all arches building properly to be able to track future regressions
> easier.  Many thanks to Guenter Roeck and Geert Uytterhoeven for their
> work in doing this.
>
> Responses should be made by Tue Aug 20 20:32:48 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.59-rc1.gz
> and the diffstat can be found below.
>

Build results:
	Total builds: 69 Total build errors: 2
Previous release:
	Total builds: 62 Total build errors: 10

qemu:
	mips, mips64, ppc, x86, x86_64: pass (boot to login prompt)
	arm: skipped

Details:
	http://server.roeck-us.net:8010/builders

More builds, significantly fewer failures, so results are excellent.

Still failing builds are arm:allmodconfig and sparc64:allmodconfig.
Both may be difficult to fix.

Thanks,
Guenter

