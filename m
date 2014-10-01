Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaJAQZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:25:07 -0400
Received: from lists.s-osg.org ([54.187.51.154]:38926 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaJAQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:25:05 -0400
Message-ID: <542C2ADB.7080206@osg.samsung.com>
Date: Wed, 01 Oct 2014 10:24:59 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 3.12 00/96] 3.12.30-stable review
References: <cover.1412147522.git.jslaby@suse.cz>
In-Reply-To: <cover.1412147522.git.jslaby@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 02:57 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.30 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> This one is special. First, it is rounded (30). Second, most of the
> patches are performance improvements. They are coming from SUSE
> Enterprise Linux and all are backed by proper testing and performance
> measurements. All this patchset was prepared and sent by Mel Gorman
> with a support of other patchers from SUSE. Thanks to all of them.
> 
> As this is special, I am gicing a whole week for responses. So
> responses should be made by Wed Oct  8 09:12:02 CEST 2014.  Anything
> received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.30-rc1.xz
> and the diffstat can be found below.
> 
> thanks,
> js
> 

Compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
