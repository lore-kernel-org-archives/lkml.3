Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaIDNkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:40:36 -0400
Received: from lists.s-osg.org ([54.187.51.154]:52882 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaIDNke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:40:34 -0400
Message-ID: <54086BD0.2020702@osg.samsung.com>
Date: Thu, 04 Sep 2014 07:40:32 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 3.16 000/125] 3.16.2-stable review
References: <20140903220623.649748296@linuxfoundation.org>
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 04:05 PM, Greg Kroah-Hartman wrote:
> --------------------------
> Note, there are a _lot_ of patches submitted for stable kernels that
> have yet to be applied, well over 200+ at the moment.  Given that this
> series is already over 100 patches, I figured it was a good as a time as
> any to push this out.  Don't worry, if you have emailed/marked patches
> to be included, and they aren't here, wait a few more releases for me to
> catch up, thanks.
> --------------------------
> 
> This is the start of the stable review cycle for the 3.16.2 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Sep  5 22:06:09 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.2-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

rc2 compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
