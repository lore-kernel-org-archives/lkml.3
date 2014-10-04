Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaJDAdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:33:10 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39348 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbaJDAdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:33:06 -0400
Message-ID: <542F403F.1010807@osg.samsung.com>
Date: Fri, 03 Oct 2014 18:33:03 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.16 000/357] 3.16.4-stable review
References: <20141003212933.458851516@linuxfoundation.org>
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 03:26 PM, Greg Kroah-Hartman wrote:
> ---------------------------------
> Note: This is a big stable release.  Mostly my fault for being on the
> road last week, combined with an unusually large number of patches being
> tagged for the stable tree.  Anyway, I've caught up with all pending
> patches before 3.17-rc7, so if you have marked something for the stable
> tree that I have not applied, or emailed the stable@v.k.o list asking
> for a patch, that is not here, please let me know.
> ---------------------------------
> 
> This is the start of the stable review cycle for the 3.16.4 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Oct  5 21:28:42 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.4-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Looking better than the previous with clean dmesg err

drm:ivb_err_int_handlererrors I was seeing went away.
Must be changes in drivers/gpu/drm/i915

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
