Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaJKXmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 19:42:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32283 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKXmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 19:42:16 -0400
Message-ID: <5439C035.8020208@oracle.com>
Date: Sat, 11 Oct 2014 19:41:41 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: paulmck@linux.vnet.ibm.com, "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rhashtable: hang while running tests on boot
References: <5437E1B3.6020409@oracle.com> <20141010142247.GU4880@linux.vnet.ibm.com> <5437ED21.2040500@oracle.com> <20141011155032.GZ4880@linux.vnet.ibm.com> <5439564E.8080105@oracle.com> <20141011222615.GB14186@casper.infradead.org>
In-Reply-To: <20141011222615.GB14186@casper.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 06:26 PM, Thomas Graf wrote:
> On 10/11/14 at 12:09pm, Sasha Levin wrote:
>> On 10/11/2014 11:50 AM, Paul E. McKenney wrote:
>>>>>>> I am guessing that this happens only when running the resizable hashtable
>>>>>>> tests -- if that guess is incorrect, please let me know.
>>>>>
>>>>> I've seen it a few times only with rhashtable related traces, if that ever
>>>>> changes I'll update - but for now I think it's safe to assume it's rhashtable
>>>>> specific.
>>> Ah, so this is intermittent.  Joy.
>>
>> Yup, I'm seeing it in about 10% of boot attempts.
> 
> Have you ever seen any traces outside of the test_rht code?  I'm
> trying to figure out whether it's a bug in the test code or in the
> hash table itself.

There are odd RCU lockups (one of which is pasted earlier in this thread),
but there's nothing pointing to rht code there, and I'm not seeing any other
rht related issues.


Thanks,
Sasha

