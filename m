Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbaELRUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:20:11 -0400
Received: from usevmg21.ericsson.net ([198.24.6.65]:50575 "EHLO
	usevmg21.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbaELRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:20:07 -0400
X-AuditID: c6180641-f799b6d000000b0f-42-5370b1114ce0
Message-ID: <537102BA.7090108@ericsson.com>
Date: Mon, 12 May 2014 13:19:54 -0400
From: Jon Maloy <jon.maloy@ericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ying Xue <ying.xue@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 072/143] tipc: fix lockdep warning during bearer initialization
References: <20140512003203.627061916@1wt.eu> <5370F0F0.1020606@ericsson.com> <20140512161613.GD19173@1wt.eu> <A2BAEFC30C8FD34388F02C9B3121859D1C250675@eusaamb103.ericsson.se> <20140512171234.GA21366@1wt.eu>
In-Reply-To: <20140512171234.GA21366@1wt.eu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.117.188.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsUyuXRPuK7gxoJgg59tmhZzzrewWFzeNYfN
	4tre48wWCzY+YrQ4Pn8Oo8Xj69eZHdg8Tk/fz+yxZeVNJo/Pm+Q81m/ZyhTAEsVlk5Kak1mW
	WqRvl8CVMa3JsuA8W8W5d6+YGxhnsnYxcnJICJhI7Nr7jA3CFpO4cG89kM3FISRwlFHiWtsX
	dghnG6PEvvcnWECqeAW0Jf7P7AGzWQRUJc5fWAw2iU1AQ+LltA5GEFtUIEyi/cJMZoh6QYmT
	M5+A1YsIyEg0TZ3OAjKUWeAro8SEN//AioQF/CRWXV7OArHtPKNEx9K7QA4HB6eAjsSMnbYg
	NcwCehJTrrYwQtjyEtvfzgHrFRJQlpj7YRoTxAuKEi+O/2SawCg0C8nuWUjaZyFpX8DIvIqR
	o7Q4tSw33chwEyMw0I9JsDnuYFzwyfIQowAHoxIP74LZBcFCrIllxZW5hxilOViUxHnTP8UG
	CwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDkXb4gTVtv1pe1siYVx6+2irFbyq6TiX4u0uIi
	yHIn0Dk1L2Dqptuyoanb22bXMxx5+HDFtyXrjl0+rrrLa3vbyz2vtuzazTZbX+EJU5lb1i3x
	P1p6oXGPkzYKGcT5qfYuzC/6PVNYTTlqp/qlS4GsTjPv23QmdPVxzWqebPvbJfX9PTlGQ0El
	luKMREMt5qLiRADmBBnrVQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 01:12 PM, Willy Tarreau wrote:
> On Mon, May 12, 2014 at 04:41:00PM +0000, Jon Maloy wrote:
>> Sorry, I should have mentioned that it is still only in net-next.
>> It is pretty recent.
> 
> OK indeed, got it here for reference :
> 
>   https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=7216cd949c9bd56
> 
> But anyway, what is mentionned in this commit is a number of changes that
> happened between 2.6.32 and 3.15, so I hardly see how the tipc_net_lock
> is obsolete in 2.6.32 if it does not have all these changes. I have counted
> 489 commits between 2.6.32 and 3.15-rc5 touching net/tipc, so surely we
> cannot count on what we have to get rid of this lock.
> 
> Am I missing anything ?

Ok. I missed the 2.6.32 part. I withdraw my objection.

///jon

> 
> Thanks,
> Willy
> 

