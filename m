Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbaLBU7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:59:49 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38986 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365AbaLBU7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:59:48 -0500
Message-ID: <547E2841.5090704@osg.samsung.com>
Date: Tue, 02 Dec 2014 13:59:45 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org, Arnd Bergmann <arnd@arndb.de>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
References: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au> <1417499528-23377-3-git-send-email-mpe@ellerman.id.au> <547DE6D8.8090209@codeaurora.org>
In-Reply-To: <547DE6D8.8090209@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 09:20 AM, Christopher Covington wrote:
> Hi Michael,
> 
> On 12/02/2014 12:52 AM, Michael Ellerman wrote:
>> Don't prevent the test building on non-x86. Just try and build it and
>> let the chips fall where they may.
>>
>> Add support for CROSS_COMPILE while we're at it. Also we don't need a
>> custom rule for building kcmp_test.
>>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> For what it's worth, all three patches look good to me.
> 
> Reviewed-by: Christopher Covington <cov@codeaurora.org>
> 
> Thanks,
> Chris
> 

All three patches queued for 3.19 - linux-kselftest.git/ fixes branch

kcmp fails on couple tests it runs when CONFIG_CHECKPOINT_RESTORE
is disabled. However, it isn't bad enough to not include the patch,
especially when there is use for it on arm.

FAIL: 0 expected but -1 returned (Function not implemented)
FAIL: 0 expected but -1 returned (Function not implemented)

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
