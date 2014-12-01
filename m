Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaLARAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:00:05 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38754 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbaLARAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:00:03 -0500
Message-ID: <547C9E92.8010606@osg.samsung.com>
Date: Mon, 01 Dec 2014 10:00:02 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au> <1417141122.6694.5.camel@concordia>
In-Reply-To: <1417141122.6694.5.camel@concordia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 07:18 PM, Michael Ellerman wrote:
> On Thu, 2014-10-23 at 16:07 +1100, Michael Ellerman wrote:
>> kcmp.h appears to be part of the API, it's documented in kcmp(2), and
>> the selftests/kcmp code uses it. So move it to uapi so it's actually
>> exported.
> 
> Looks like this series fell through the cracks?
> 
> It still applies on rc6. Should I resend?
> 
> cheers
> 
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

I am expecting a patch v2 for the series based on the comments
on the series. Please see my responses to the individual patch
threads.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
