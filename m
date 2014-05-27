Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaE0Wvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:51:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE0Wvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:51:41 -0400
Message-ID: <538516EE.40209@infradead.org>
Date: Tue, 27 May 2014 15:51:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
CC: "T. Makphaibulchoke" <tmac@hp.com>,
        Andreas Gruenbacher <a.gruenbacher@computer.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.15-rc6  build / link failed  fs/built-in  mb_cache_entry problems
References: <redirect-87012843@zbackend1.aha.ru> <53841CED.9010800@infradead.org> <5385101D.4050504@hp.com>
In-Reply-To: <5385101D.4050504@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 03:22 PM, Thavatchai Makphaibulchoke wrote:
> On 05/26/2014 11:04 PM, Randy Dunlap wrote:
>> On 05/26/2014 11:17 AM, werner wrote:
>> @tmac:  can mbcache.c #include <linux/log2.h> and use ilog2(NR_BG_LOCKS)
>> instead of using __builtin_log2(NR_BG_LOCKS) ?
>> (ref. commit ID 1f3e55fe02d12213f87869768aa2b0bad3ba9a7d)
>>
> 
> I don't see any problem with that, unless somebody else has any concern.  Please let me know if you'd like me to submit the change.

I'd say yes since some gcc version(s) don't seem to support __builtin_log2().

-- 
~Randy
