Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3G2OIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:08:47 -0400
Received: from chicago.guarana.org ([192.210.136.102]:50171 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3G2OIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:08:46 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 10:08:46 EDT
Message-ID: <20130730000103.35524r83mpydvs7z@chicago.guarana.org>
Date: Tue, 30 Jul 2013 00:01:03 +1000
From: Kevin Easton <kevin@guarana.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, davem@davemloft.net,
        arnd@arndb.de, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
References: <20130727225828.GA11864@linux.vnet.ibm.com>
 <20130729153035.18805zox54aoyubf@chicago.guarana.org>
 <20130729135411.GM26694@linux.vnet.ibm.com>
In-Reply-To: <20130729135411.GM26694@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>:

> On Mon, Jul 29, 2013 at 03:30:35PM +1000, caf@guarana.org wrote:
>> Quoting "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>:
>>
...
>> >
>> >Note that the C standard considers the cast from signed to
>> >unsigned to be implementation-defined, see 6.3.1.3p3.
...
>>
>> Don't worry, the case from signed to unsigned is actually well-defined -
>> the relevant part is 6.3.1.3p2 (in C99):
>>
>> >Otherwise, if the new type is unsigned, the value is converted by
>> >repeatedly adding or subtracting one more than the maximum value that
>> >can be represented in the new type until the value is in the range of
>> >the new type.
>
> Yep, but we are going in the other direction, from unsigned to signed.

Ahh, there's an error in the commit message (it says signed to unsigned).

     - Kevin

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

