Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaIXDVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:21:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIXDVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:21:53 -0400
Message-ID: <542238CF.30505@codeaurora.org>
Date: Tue, 23 Sep 2014 20:21:51 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: nick <yocto6@gmail.com>, linux@arm.linux.org.uk
CC: steve.capper@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
        steve.capper@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: FIX Me in pgtable.h
References: <54216FC9.5060605@gmail.com>
In-Reply-To: <54216FC9.5060605@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2014 6:04 AM, nick wrote:
> Greetings Arm Maintainers,
> I am wondering about the fix me in pgtable.h for define kern_addr_valid and how to set it to a correct
> value as you state that this needs to be fixed as the defined macro is still 1. This is probably incorrect
> and should be changed.
> Thanks,
> Nick
>

It's not clear to me how valuable fixing kern_addr_valid would actually
be for arm. It seems to be used in exactly one place, fs/proc/kcore.c
and the associated Kconfig is explicitly marked if !ARM. Nearly all
other archs minus x86, arm64 and sparc are in the same boat as well.

Thanks,
Laura

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, hosted by The Linux Foundation
