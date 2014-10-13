Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaJMQok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:44:40 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:14350 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbaJMQoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:44:39 -0400
Message-ID: <543C0176.5050706@c-s.fr>
Date: Mon, 13 Oct 2014 18:44:38 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v3 00/21] powerpc/8xx: Optimise MMU TLB handling and add
 support of 16k pages
References: <20140917163656.E09D81AB026@localhost.localdomain>	 <1410972043.24184.532.camel@snotra.buserror.net> <5419F017.8010603@c-s.fr> <1410986079.24184.534.camel@snotra.buserror.net>
In-Reply-To: <1410986079.24184.534.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 17/09/2014 22:34, Scott Wood a écrit :
> On Wed, 2014-09-17 at 22:33 +0200, christophe leroy wrote:
>> Le 17/09/2014 18:40, Scott Wood a écrit :
>>> On Wed, 2014-09-17 at 18:36 +0200, Christophe Leroy wrote:
>>>> This patchset:
>>>> 1) provides several MMU TLB handling optimisation on MPC8xx.
>>>> 2) adds support of 16k pages on MPC8xx.
>>>> All changes have been successfully tested on a custom board equipped with MPC885
>>>>
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>> Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>> I've already applied patches 1, 2, 4, 5, 6, 9, and 10 from the previous
>>> patchset -- have they changed?
>>>
>>> -Scott
>>>
>> No, only 3, 7, 17 are changed, and 20,21 are new.
>> I didn't notice you already applied some. How should I then proceed now
>> for the remaining ones ? Submit a new set ?
>>
> No, I'll just skip the ones I've already applied.
>
>
I think I took into account all Joakim's and your's comments in v4.
Since I submitted v4, I think I didn't get any new comment.
What's the way forward to get the remaining ones applied ?

Christophe
