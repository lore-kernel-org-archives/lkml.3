Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3CUJtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:49:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33514 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab3CUJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:49:08 -0400
Message-ID: <514AD76D.2020401@imgtec.com>
Date: Thu, 21 Mar 2013 09:48:29 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tejun Heo <tj@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-sh@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: kill "config MAX_ACTIVE_REGIONS"
References: <1363858076.1390.104.camel@x61.thuisdomein> <20130321093455.GA8027@linux-sh.org>
In-Reply-To: <20130321093455.GA8027@linux-sh.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_21_09_48_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/13 09:34, Paul Mundt wrote:
> On Thu, Mar 21, 2013 at 10:27:56AM +0100, Paul Bolle wrote:
>> The Kconfig symbol MAX_ACTIVE_REGIONS is unused. Commit
>> 0ee332c1451869963626bf9cac88f165a90990e1 ("memblock: Kill
>> early_node_map[]") removed the only place were it was actually used. But
>> it did not remove its Kconfig entries (for powerpc and sh).
>>
>> Remove those two entries (and the entry for metag, that popped up in
>> v3.9-rc1).
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) Eyeball tested again.
>>
>> 1) It felt silly to split this clean up patch into three patches. But if
>> the maintainers involved disagree I'm happy to split and resend it. 
>>
> Given that it's unused now it doesn't really matter how it gets applied,
> it looks fine to me.
> 
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> 

Acked-by: James Hogan <james.hogan@imgtec.com>

