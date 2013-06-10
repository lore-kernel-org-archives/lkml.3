Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3FJSg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:36:29 -0400
Received: from dinosaur.yandex.ru ([77.88.34.8]:9476 "EHLO dinosaur.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab3FJSgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:36:23 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 14:36:23 EDT
Message-ID: <51B61B22.2010604@yandex-team.ru>
Date: Mon, 10 Jun 2013 22:29:54 +0400
From: "Boris B. Zhmurov" <zhmurov@yandex-team.ru>
Reply-To: zhmurov@yandex-team.ru
Organization: Yandex LLC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com, klamm@yandex-team.ru,
        brouer@redhat.com, dipankar@in.ibm.com, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, David.Laight@ACULAB.COM, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
References: <1370229169.24311.119.camel@edumazet-glaptop> <20130602.202703.1059637861388689182.davem@davemloft.net> <20130603034254.GC29614@linux.vnet.ibm.com> <20130602.204915.334823676645400072.davem@davemloft.net>
In-Reply-To: <20130602.204915.334823676645400072.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 07:49 AM, David Miller wrote:


>>>> Well, whole discussion went on linux kernel, and you were the original
>>>> committer of this patch five years ago.
>>>>
>>>> http://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=bbaffaca4810de1a25e32ecaf836eeaacc7a3d11
>>>>
>>>> So please Paul or David make sure the patch goes in.
>>>>
>>>> My only concern is that Paul seems quite busy these days.
>>>
>>> Ok I can take it then, no problem.
>>
>> Or if you would like to take it:
>>
>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Let's end this deadlock by me taking it :-)


Hello David,

Do you think, this patch is "stable material" and should be included in
3.0-stable and 3.4-stable trees? Thanks.

-- 
Boris B. Zhmurov
Yandex.Search SRE Team
*************
т.: +7 (495) 739-70-00 ext.7160
http://yandex.ru
*************
