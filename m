Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3GTVfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 17:35:38 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:25077 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3GTVfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 17:35:36 -0400
X-AuditID: cbfec37b-b7f306d0000047de-6c-51eb02a7788a
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, CAI Qian <caiqian@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>
Subject: Re: [Ksummit-2013-discuss] Maybe it's time to shut this thread down
 (Was: Re: [ 00/19] 3.10.1-stable review)
Thread-topic: [Ksummit-2013-discuss] Maybe it's time to shut this thread down
 (Was: Re: [ 00/19] 3.10.1-stable review)
Thread-index: Ac6FkRCisDb5r2eeQr+ZSZ5Wfl77ZQ==
Date: Sat, 20 Jul 2013 21:35:33 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE8861AA4D@sisaex01sj>
References: <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
 <1368728064.2419741.1374117402465.JavaMail.root@redhat.com>
 <1374119254.6458.220.camel@gandalf.local.home>
 <305037674.2433057.1374120078349.JavaMail.root@redhat.com>
 <20130718132327.GB30405@thunk.org> <20130718133008.GC30405@thunk.org>
 <20130718155428.GB5440@xanatos>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9hP93lTK8DDWb3ClvMWb+GzaJz11FW
	iy3Xm5gs7hzWsGhevJ7NYvaEeawWl3fNYbN4svAMk8Xqf6cYLfZ1PGCyaD5xitliwcZHjBab
	N01ltnjU95bdorXnJ7sDv0fLvlvsHptWdbJ5vDt3jt3jxIzfLB7zTgZ67J+7ht1j8o3ljB5N
	Z44ye7zfd5XNY+f3BnaPz5vkArijuGxSUnMyy1KL9O0SuDLermEtWMNacePsGuYGxrUsXYwc
	HBICJhLTlxl2MXICmWISF+6tZ+ti5OIQEljGKDHnYxMLSEJIoJdJYsmsIojEfEaJnQ8uMoIk
	2ATMJJYeP8MEYosI6EtMnNoD1s0s8JVF4uqzdewgCWGBcokp97oYIYoqJFZc+80GYetJPHy0
	lRXEZhFQlXjVsAGshlfAXmLi/jssENu2sEhMON3IDJJgBLrv+6k1YNuYBcQlmltvskDcLSCx
	ZM95ZghbVOLl43+sEK8pSmxfbQVRriWxfudxqFZtiSfvLrBC7BKU+DH5HssERrFZSKbOQtIy
	C0nLLCQtCxhZVjGKlRYnFxQnpadWGOkVJ+YWl+al6yXn525ihKSF6h2Md7/aHGIU4GBU4uGN
	YHwdKMSaWFZcmXuIUYKDWUmE1/LZq0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjNVB3wskHqpY
	TtFfmrPP4WFTD8uDdQVT3bcmlqW9YTcMN1Xw6P1WyPVaxDFR4ZjW/NYZG5Srg+d47Ym7bzJX
	Pjoh9K6w2il/u5eekc9Skj+ZClaKqNcx9wh5JJj4/o09+1Hgbrr5luz6W34u8x7P4JETnCq/
	weotz7JslnOqDp9OsN/X6klRYinOSDTUYi4qTgQANfZhHukCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 03:54 PM, Sarah Sharp wrote:
> Let's shift this discussion away from the terms "abuse" and
> "professionalism" to "respect" and "civility".

Brilliant, and +1 for a session at KS. In the mean time, why don't we 
all try to demonstrate the real meaning of respect and civility, by 
practising it henceforth on LKML? KS ought to be about clarification, 
reinforcement and specific techniques, as opposed to the question of 
whether respect and civility are desirable in the first place. Nobody 
needs to wait for KS to learn the basic truth they already know in their 
heart.

Regards,

Daniel
