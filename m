Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaLFVgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 16:36:46 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39615 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaLFVgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 16:36:45 -0500
Message-ID: <548376EB.5000005@osg.samsung.com>
Date: Sat, 06 Dec 2014 14:36:43 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/45] 3.10.62-stable review
References: <20141205223316.738290875@linuxfoundation.org>
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 03:44 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.62 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Dec  7 22:32:54 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.62-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
