Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3LLH7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:59:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44619 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3LLH7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:59:04 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1386828303.6056.40.camel@marge.simpson.net>
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de> <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <1386764955.12005.60.camel@marge.simpson.net> <20131211124352.GB21999@twins.programming.kicks-ass.net> <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com> <20131211164318.GA2480@laptop.programming.kicks-ass.net> <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com> <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com> <1386822357.6056.12.camel@marge.simpson.net> <52A94065.1050103@zytor.com> <1386826641.6056.31.camel@marge.simpson.net> <6e4b858b-fcad-4231-8351-d2f473bf6ba6@email.android.com> <1386827824.6056.36.camel@marge.simpson.net> <1386828303.6056.40.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 11 Dec 2013 23:57:36 -0800
To: Mike Galbraith <bitbucket@online.de>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Message-ID: <b0cb5d8b-610c-44b1-b937-68f4a968bfa1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm guessing there is an implicit or explicit wake-up somewhere that I managed to miss.  If it is implicit it could be hard to catch.

Mike Galbraith <bitbucket@online.de> wrote:
>On Thu, 2013-12-12 at 06:57 +0100, Mike Galbraith wrote: 
>> On Wed, 2013-12-11 at 21:45 -0800, H. Peter Anvin wrote: 
>> > As in it hangs at that point?
>> 
>> Nope, it's still going.
>> 
>> [1567.578340] pcc-cpufreq: (v1.10.00) driver loaded with frequency
>limits: 1064 MHz, 2266 MHz
>> 
>> Funny, continents move faster :)  Maybe missing a write or two.
>
>When I get back it may be done booting.  I'm gonna let it try for grins
>while I'm away, then take a peek, see if I can spot it.
>
>[ 1567.578340] pcc-cpufreq: (v1.10.00) driver loaded with frequency
>limits: 1064 MHz, 2266 MHz
>                                                                   done
>Starting HAL daemon                                                  
>done
>
>
>Setting up (localfs) network interfaces:
>    lo        
>    lo        IP address: 127.0.0.1/8   
>           IP address: 127.0.0.2/8                                 done
>    eth0      device: Broadcom Corporation NetXtreme II BCM5709 Gig
>         No configuration found for eth0                         unused
>    eth1      device: Broadcom Corporation NetXtreme II BCM5709 Gig
>         No configuration found for eth1                         unused
>    eth2      device: NetXen Incorporated NX3031 Multifunction 1/10
>[ 2457.114007] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
>[ 2457.114455] netxen_nic: eth2 NIC Link is up
>[ 2457.223582] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
>    eth2      IP address: 0.0.0.0/32

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
