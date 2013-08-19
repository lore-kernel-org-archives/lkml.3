Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3HSBjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:39:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59756 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3HSBjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:39:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52117741.4070304@roeck-us.net>
Date: Sun, 18 Aug 2013 18:39:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/12] 3.0.92-stable review
References: <20130818202949.875887601@linuxfoundation.org>
In-Reply-To: <20130818202949.875887601@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 01:30 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.92 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Aug 20 20:29:24 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.92-rc1.gz
> and the diffstat can be found below.
>

Cross build results (including commit ea077b1b96):
	Total builds: 65 Total build errors: 8
Previous release:
	Total builds: 58 Total build errors: 14

qemu tests:
	ppc, x86, x86_64 tested ok
	arm, mips, mips64 skipped

More builds, fewer failures. Excellent results.

Build details are at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter

