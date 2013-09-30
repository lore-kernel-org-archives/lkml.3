Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3I3B0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:26:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60954 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3I3B0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:26:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5248D32A.40203@roeck-us.net>
Date: Sun, 29 Sep 2013 18:26:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/22] 3.4.64-stable review
References: <20130929191158.889693326@linuxfoundation.org>
In-Reply-To: <20130929191158.889693326@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.64 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:11:47 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.64-rc1.gz
> and the diffstat can be found below.
>

Build test results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu:
	microblaze, mips, mips64, ppc, sh, sparc, x86, x86_64 pass.
	arm, sparc64 skipped

Same results as with 3.4.63.

Guenter

