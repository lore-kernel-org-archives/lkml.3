Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaLPDHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:07:14 -0500
Received: from lists.s-osg.org ([54.187.51.154]:40323 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaLPDHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:07:12 -0500
Message-ID: <548FA1DF.30001@osg.samsung.com>
Date: Mon, 15 Dec 2014 20:07:11 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.17 00/47] 3.17.7-stable review
References: <20141214201818.552715149@linuxfoundation.org>
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 01:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.17.7 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Dec 16 20:18:09 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.7-rc1.gz
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
