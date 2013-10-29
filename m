Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab3J2BKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:10:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31006 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab3J2BKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:10:36 -0400
X-Spam-Score: -100.8
Message-ID: <526F0ACF.8010201@asianux.com>
Date: Tue, 29 Oct 2013 09:09:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: export symbol for save_stack_trace() in
 stacktrace.c
References: <526DD356.5020101@asianux.com> <526E6F58.8040405@synopsys.com>
In-Reply-To: <526E6F58.8040405@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 10:06 PM, Vineet Gupta wrote:
> On 10/28/2013 08:30 AM, Chen Gang wrote:
>> Need export its symbol just like other architectures done, or can not
>> pass compiling with allmodconfig, the related error:
>>
>>     MODPOST 2994 modules
>>   ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
>>   ERROR: "save_stack_trace" [drivers/md/persistent-data/dm-persistent-data.ko] undefined!
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Applied for 3.13
> 

Thanks.
-- 
Chen Gang
