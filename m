Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaHHKcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:32:43 -0400
Received: from sf1.bxl.stone.is ([87.238.167.36]:32839 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbaHHKcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:32:41 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53E4A73D.5080801@acm.org>
Date: Fri, 08 Aug 2014 12:32:29 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] spin_lock_nested(): Always evaluate second argument
References: <53CE1019.10708@acm.org> <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org> <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com> <53E260D9.6030803@acm.org> <53E2618F.6040208@acm.org> <alpine.DEB.2.02.1408061455290.13545@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1408061455290.13545@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Filter-ID: XtLePq6GTMn8G68F0EmQvdthj6rk7ohlAkaRQG+cDaLZlN3ufQ0ZRHdy43341LQ0JYRGiu4wDuX/
 sGw1Y7RAsZ3WBw9ZlycipwBG3jGu9D8JBgu10R0foqIRsBJqRnurUO/XCGxJVedBWv8BXp6lSPrf
 oA0XngOaR5RLFk6kKY8+X6tyUZ34Ozy6TOwmaHPzFR2lHDoBQ4zwtMehH4SfWgLcNhHqvET8hkHK
 4DD3CZT4SL0VvzAbTStaxE3e6xctxkHXgTSJC2+q+O2n2sPwh+CpLQk2sgUsKd5RNPNJeN3I5L/U
 AJH41ve/RciJD7RwcMm6IODZgOZ9Y8BEoKFU+ThPpKKNyD6EWtbIyxh4MHoccBIk1Sag4dKiqCrF
 8eZZsQYibGPulATAPqOguWXWenmy4p4jVbvkvQrOImHI+zH4ns3e6vWEaK66hz4t87L5hVQSL57W
 w8nd1cTP1twpFFTUuHOuOBA828Pfce2frIKvtUus/ypEW5W6Dw4DmSZF9OoIMWCP9bnVs5BJWbbt
 5dM+m4WpRRDP6YzwkAPgQJZcv8AnfPB9HqHgcyCJwUz8oOSQKVK4yyKUlGmQMgPOfIQtTQXMrNAv
 J7CbCYezRVuhdlkpfoNhtgWYwB/e4S2rpoRvMJWweGFGUUnI6wOX8j4FS3UlU37B6qPMab0LB93J
 IFkIZaBCBQxuHnm838r5oXZZKX6DYbYFmMAf3uEtq0CVt0DUeFU/MBWnkHtFiUWUs1IAPjDts3+I
 etSNQKiFa27IsDu2NxxouWmZdcGOChVo3Ylh8ywfjYp979CTGJlcA0OL1mkTp3S7nD3AxhtVMS+4
 ayUpOtEhdxekWDmK9g==
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: cPaH8lomer6UwsJ3BnJDyh/24V0ZnPLChpTdx0aQyMi0VFDyP20las9Mq1v6nXmfrqKtWpHLpkE8
 c09GKJn2t//Iv3SA9yqL/o+tgER5K01MqRJTan78INzQLlEGX/jFRST5X0bRoOLYozD+qqgg13U4
 H51jyCSmLdA2hPaiVpwYWaeThsiFlmPt/lOSmjPeIry8YqBAImlpW4iUkiWie2qK95LAXg+Ea3Jb
 F9WwpaZ//Un1C5ivAWoOksRE8XtOTT9J6CK2j8j7/AJ9TNml+IbyXSJXjZjMx+Tok7jY2RMVEkZR
 xMpnILpnPlb/BDIPR3BzrtNvug17DaoVb9RvKuKFkKyIMhEyqFjdRcrNMObE3nrK/nhevL/uAoHg
 xNXar0XzbLB8Pru9OEB7tNjak+6bpnvFzMd6SECQNf1u/wGWAJzP31LdUHDVnH0aZDcVCxO6ac9X
 hDc8gFJxmNF1qg==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.02)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/14 23:56, David Rientjes wrote:
> On Wed, 6 Aug 2014, Bart Van Assche wrote:
>> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
>> index 3f2867f..485d5dc 100644
>> --- a/include/linux/spinlock.h
>> +++ b/include/linux/spinlock.h
>> @@ -197,7 +197,8 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>>  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
>>  	 } while (0)
>>  #else
>> -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
>> +# define raw_spin_lock_nested(lock, subclass)		\
>> +	((void)(subclass), _raw_spin_lock(lock))
>>  # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
>>  #endif
>>  
> 
> I think it would be nice to comment why we're evaluating the subclass when 
> CONFIG_DEBUG_LOCK_ALLOC=n so that nobody comes along and unknowingly 
> changes it back.
> 
> Thanks for posting the updated version and keeping at it!

This morning I received an e-mail from Wu Fengguang reporting that this
patch breaks the build for CONFIG_SMP=n. I will post a third version.

Bart.
