Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab3GaAHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:07:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15559 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3GaAHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:07:17 -0400
X-Spam-Score: -100.8
Message-ID: <51F854F7.2080504@asianux.com>
Date: Wed, 31 Jul 2013 08:06:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: jaharkes@cs.cmu.edu, coda@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] include/linux/coda.h: remove useless '#else'
References: <51F76B7D.2090602@asianux.com> <alpine.LNX.2.00.1307301238230.18809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307301238230.18809@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 06:38 PM, Jiri Kosina wrote:
> On Tue, 30 Jul 2013, Chen Gang wrote:
> 
>> '#else' is useless, need remove.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  include/linux/coda.h |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/coda.h b/include/linux/coda.h
>> index cff544f..d30209b 100644
>> --- a/include/linux/coda.h
>> +++ b/include/linux/coda.h
>> @@ -60,7 +60,6 @@ Mellon the rights to redistribute these changes without encumbrance.
>>  
>>  #if defined(__linux__)
>>  typedef unsigned long long u_quad_t;
>> -#else
>>  #endif
>>  #include <uapi/linux/coda.h>
>>  #endif 
> 
> Applied.
> 

Thanks.

-- 
Chen Gang
