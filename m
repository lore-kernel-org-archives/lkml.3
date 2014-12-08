Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaLHQer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:34:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48238 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaLHQeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:34:46 -0500
Message-ID: <5485D316.9080001@oracle.com>
Date: Mon, 08 Dec 2014 11:34:30 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?windows-1252?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com> <5481C92E.6020805@oracle.com> <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com> <54846B06.8050906@oracle.com> <20141207182420.GG25340@linux.vnet.ibm.com> <20141207194304.GA17810@linux.vnet.ibm.com> <5484E2AB.1070503@oracle.com> <20141208052048.GJ25340@linux.vnet.ibm.com> <5485B6B9.7010800@oracle.com> <5485C3B5.4000401@oracle.com> <20141208155745.GM25340@linux.vnet.ibm.com>
In-Reply-To: <20141208155745.GM25340@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 10:57 AM, Paul E. McKenney wrote:
> On Mon, Dec 08, 2014 at 10:28:53AM -0500, Sasha Levin wrote:
>> > On 12/08/2014 09:33 AM, Sasha Levin wrote:
>>> > > On 12/08/2014 12:20 AM, Paul E. McKenney wrote:
>>>>> > >> > I have seen this caused by lost IPIs, but you have to lose two of them,
>>>>> > >> > which seems less than fully likely.
>>> > > It does seem that it can cause full blown stalls as well, just pretty
>>> > > rarely (notice the lack of any prints before):
>> > 
>> > Forgot to mentioned, I cranked the rcu lockup timeout to 300 seconds and got
>> > that stall.
> So with the default of 21 seconds, you presumably get huge numbers of
> RCU CPU stall warnings?

Yes, I'm seeing 1 lockup every ~5 minutes on my set up.

The traces do seem to be different every time.


Thanks,
Sasha
