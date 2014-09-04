Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaIDNgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:36:35 -0400
Received: from lists.s-osg.org ([54.187.51.154]:52867 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaIDNgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:36:33 -0400
Message-ID: <54086ADF.3090901@osg.samsung.com>
Date: Thu, 04 Sep 2014 07:36:31 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, alexander.usyskin@intel.com
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 3.10 00/55] 3.10.54-stable review
References: <20140903220453.653576908@linuxfoundation.org>
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 04:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.54 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Sep  5 22:04:21 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.54-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

rc-2 compiled and booted on my test system. There is one regression
in dmesg with mei:

mei_me 0000:00:16.0: version message writet failed
mei_me 0000:00:16.0: version message writet failed

Could this be related to:

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: nfc: fix memory leak in error path

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: reset client state on queued connect request

These two patches are in 3.14 and 3.16 as well and I didn't
see this regression on those.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
