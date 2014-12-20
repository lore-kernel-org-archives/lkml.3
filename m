Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaLTPsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 10:48:19 -0500
Received: from mout.gmx.net ([212.227.15.19]:62794 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbaLTPsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 10:48:16 -0500
Message-ID: <54959A3A.4030104@gmx.de>
Date: Sat, 20 Dec 2014 16:48:10 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>
CC: David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
References: <548B1E44.6050005@users.sourceforge.net>	<20141212.115922.687789059853236747.davem@davemloft.net>	<54930D7C.3000901@users.sourceforge.net> <20141218.122556.2148647081075440879.davem@davemloft.net> <54958B8C.7010105@users.sourceforge.net>
In-Reply-To: <54958B8C.7010105@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:31bjLUje8u5/oxNtd3XhP9nUE86SMqmO01B/RL8U5pBGrWH83G8
 KvoBM7KtEsZOe2dF2OVTQIf/8dEZv5HaX/iDln1NEX4E3dtmMk+rHkU5Wi0q6Sh5udqhOLC
 b/2US+OhTnZlZD1OQanDm2j8Y4j+KSt3ieaRht5mz8bjy0pMhRHYlwGzCcmIbw9R0MtFo7o
 6K4rZe8OL/5rVqEw/7WIQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On 20.12.2014 15:45, SF Markus Elfring wrote:
>> I'm saying to leave the code alone.
> 
> Do I need to try another interpretation out for your feedback?
> 
> 
>> If it goes:
>> 
>> 	var = foo_that_returns_ptr_err()
>> 	if (IS_ERR(var))
>> 		return PTR_ERR(var);
>> 
>> 	p->bar = var;
>> 
>> or whatever, simply keep it that way!
> 
> Do you want to express here that a data structure member should
> only be set after a previous function call succeeded?
> 

I think what David said was pretty clear: If you see code like the above
there is no need to refactor it. That does not mean that this is the
_preferred_ way of error handling. Its just good enough to be left alone.

Regards,
Lino
