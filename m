Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHVTrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:47:18 -0400
Received: from lists.s-osg.org ([54.187.51.154]:51488 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaHVTrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:47:15 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2014 15:47:14 EDT
Message-ID: <53F79C25.6010405@osg.samsung.com>
Date: Fri, 22 Aug 2014 13:38:13 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/104] 3.12.27-stable review
References: <cover.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 05:43 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.27 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Aug 22 13:43:20 CEST 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.27-rc1.xz
> and the diffstat can be found below.
>
> thanks,
> js
>

Compiled and booted on my test system. No dmesg regressions.
I pulled the patch this morning, hoping add-basic-validations
patch has been removed.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
