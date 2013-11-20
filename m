Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3KTJWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:22:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24917 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:22:33 -0500
Message-ID: <528C7F4B.3050802@oracle.com>
Date: Wed, 20 Nov 2013 17:22:19 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Bob Liu <lliubbo@gmail.com>, ian.campbell@citrix.com,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: [PATCH] xen: tmem: rmove useless parameters
References: <1384937575-25168-1-git-send-email-bob.liu@oracle.com> <528C8A980200007800104E69@nat28.tlf.novell.com>
In-Reply-To: <528C8A980200007800104E69@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/20/2013 05:10 PM, Jan Beulich wrote:
>>>> On 20.11.13 at 09:52, Bob Liu <lliubbo@gmail.com> wrote:
>> @@ -100,9 +100,6 @@ static inline int xen_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
>>  	op.u.gen.oid[1] = oid.oid[1];
>>  	op.u.gen.oid[2] = oid.oid[2];
>>  	op.u.gen.index = index;
>> -	op.u.gen.tmem_offset = tmem_offset;
>> -	op.u.gen.pfn_offset = pfn_offset;
>> -	op.u.gen.len = len;
> 
> But you can't leave these fields uninitialized.
> 

Oh, yes.
And I should remove those members totally from struct tmem_op {}

-- 
Thanks,
-Bob
