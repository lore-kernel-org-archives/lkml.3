Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab3HBJAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:00:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45982 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3HBJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:00:47 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-62-51fb753d1418
Message-id: <51FB753C.1080809@samsung.com>
Date: Fri, 02 Aug 2013 11:00:44 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2] security: smack: add a hash table to quicken
 smk_find_entry()
References: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com>
 <1370955313-3605-2-git-send-email-t.stanislaws@samsung.com>
 <51CCAA7C.2070606@schaufler-ca.com> <51FAF62F.9090301@schaufler-ca.com>
In-reply-to: <51FAF62F.9090301@schaufler-ca.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xq7q2pb8DDbp3G1vc2/aLzeJs0xt2
	i8u75rBZfOh5xGax9shddou3k1YwO7B59G1ZxehxdP8iNo/Pm+QCmKO4bFJSczLLUov07RK4
	Mi73FBe85qiYd+wgSwPjLPYuRk4OCQETiUlfbrFA2GISF+6tZwOxhQSWMkp8nKsNYX9mlHj6
	uaaLkYODV0BL4sGJeJAwi4CqxKHdnawgNhvQmGNLPjOClIgKREgcXa4JEuYVEJT4Mfke2HQR
	AR2JfXueA23l4mAWmMwo8f1sHxNIQlggROJ1010WkISQwHlGicPdv5hBEpwCBhJrTn0AW8AM
	1L2/dRobhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNz
	NzFCQvjLDsbFx6wOMQpwMCrx8O5U/x0oxJpYVlyZe4hRgoNZSYT3z+xfgUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYGc6VHdA0a3l88vv925uPMqstUuidtJ7VoaTt8MV3uZwG5Xtcejp7yjj2
	9aaHcEUcZllRq2YWEynkYHd521PmPzlqR5Z2nZRQYTQJjbk5f5G6oP3ay7dnbPj/W6M13N7T
	tP6rmt2hvgdVnNXibuyrZ/4M/SLrJMC5NO6t7Lp70qWCLEurWX8rsRRnJBpqMRcVJwIACugm
	4z8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 01:58 AM, Casey Schaufler wrote:
> On 6/27/2013 2:11 PM, Casey Schaufler wrote:
>> On 6/11/2013 5:55 AM, Tomasz Stanislawski wrote:
>>> This patch adds a hash table to quicken searching of a smack label by its name.
>>>
>>> Basically, the patch improves performance of SMACK initialization.  Parsing of
>>> rules involves translation from a string to a smack_known (aka label) entity
>>> which is done in smk_find_entry().

[snip]

>> I will take this into my tree after changing SMACK_HASH_SLOTS to 16.
>>
>> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.12
> 
> Rebasing was required. The change has been tested.
> 
> 

Hi,
Thanks for merging the patch.
BTW. Do you have comments about:

http://thread.gmane.org/gmane.linux.kernel.lsm/19650

Here I posted all of the acceptable patches rebased on smack-next.
Moreover, I added measurements of impact of patches on both time and
memory consumption.
There were no comments about this patchset. Maybe something was lost?

Regards,
Tomasz Stanislawski


