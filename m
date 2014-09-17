Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaIQUdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:33:43 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44596 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbaIQUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:33:41 -0400
Message-ID: <5419F017.8010603@c-s.fr>
Date: Wed, 17 Sep 2014 22:33:27 +0200
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v3 00/21] powerpc/8xx: Optimise MMU TLB handling and add
 support of 16k pages
References: <20140917163656.E09D81AB026@localhost.localdomain> <1410972043.24184.532.camel@snotra.buserror.net>
In-Reply-To: <1410972043.24184.532.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 140917-1, 17/09/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 17/09/2014 18:40, Scott Wood a écrit :
> On Wed, 2014-09-17 at 18:36 +0200, Christophe Leroy wrote:
>> This patchset:
>> 1) provides several MMU TLB handling optimisation on MPC8xx.
>> 2) adds support of 16k pages on MPC8xx.
>> All changes have been successfully tested on a custom board equipped with MPC885
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
> I've already applied patches 1, 2, 4, 5, 6, 9, and 10 from the previous
> patchset -- have they changed?
>
> -Scott
>
No, only 3, 7, 17 are changed, and 20,21 are new.
I didn't notice you already applied some. How should I then proceed now 
for the remaining ones ? Submit a new set ?

Thanks
Christophe

---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com

