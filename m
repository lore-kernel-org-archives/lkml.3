Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3HZBMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:12:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8693 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3HZBMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:12:37 -0400
X-Spam-Score: -101.0
Message-ID: <521AAB43.3080604@asianux.com>
Date: Mon, 26 Aug 2013 09:11:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/padata.c: share code between CPU_ONLINE and
 CPU_DOWN_FAILED, same to CPU_DOWN_PREPARE and CPU_UP_CANCELED
References: <5212E5E4.8010408@asianux.com> <5212E61F.7010602@asianux.com> <20130822051122.GB26773@secunet.com> <5215A134.90607@asianux.com> <20130822060503.GC26773@secunet.com> <5215B319.3020908@asianux.com> <20130823104448.GI26773@secunet.com> <20130823104731.GA30865@gondor.apana.org.au>
In-Reply-To: <20130823104731.GA30865@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 06:47 PM, Herbert Xu wrote:
> On Fri, Aug 23, 2013 at 12:44:48PM +0200, Steffen Klassert wrote:
>> On Thu, Aug 22, 2013 at 02:43:37PM +0800, Chen Gang wrote:
>>> Share code between CPU_ONLINE and CPU_DOWN_FAILED, same to
>>> CPU_DOWN_PREPARE and CPU_UP_CANCELED.
>>>
>>> It will fix 2 bugs:
>>>
>>>   "not check the return value of __padata_remove_cpu() and __padata_add_cpu()".
>>>   "need add 'break' between CPU_UP_CANCELED and CPU_DOWN_FAILED".
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>
>> This looks ok to me, Herbert can you take this one?
> 
> Sure.
> 

Thank you all.

> Thanks,
> 

Thanks.
-- 
Chen Gang
