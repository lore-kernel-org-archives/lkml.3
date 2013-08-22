Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3HVF2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:28:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61925 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3HVF2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:28:19 -0400
X-Spam-Score: -101.0
Message-ID: <5215A134.90607@asianux.com>
Date: Thu, 22 Aug 2013 13:27:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steffen Klassert <steffen.klassert@secunet.com>
CC: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/padata.c: always check the return value of __padata_remove_cpu()
 and __padata_add_cpu()
References: <5212E5E4.8010408@asianux.com> <5212E61F.7010602@asianux.com> <20130822051122.GB26773@secunet.com>
In-Reply-To: <20130822051122.GB26773@secunet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 01:11 PM, Steffen Klassert wrote:
> On Tue, Aug 20, 2013 at 11:44:31AM +0800, Chen Gang wrote:
>>
>> If this patch is correct, better to let CPU_ONLINE and CPU_DOWN_FAILED
>> share the same code.
>>
>> And do we need a comment "/* fall through */" between CPU_UP_CANCELED
>> and CPU_DOWN_FAILED (or it is another bug, need a 'break' statement) ?
>>
>> At last, also better to let CPU_DOWN_PREPARE and CPU_UP_CANCELED share
>> the same code (if need a 'break'), or share the most of code (if "fall
>> through").
>>
> 
> CPU_ONLINE and CPU_DOWN_FAILED can share the code. Same is true for
> CPU_DOWN_PREPARE and CPU_UP_CANCELED.
> 
> Thanks!
> 
> 

Thank you too.

And need I send another patch for it ?

Or just make by yourself (and better to mark me as Reported-by). :-)


Thanks.
-- 
Chen Gang
