Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaFBTk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:40:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40281 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaFBTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:40:54 -0400
Message-ID: <538CD336.4080103@infradead.org>
Date: Mon, 02 Jun 2014 12:40:38 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, paulmck@linux.vnet.ibm.com
CC: josh@joshtriplett.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>	 <1401731968.7323.4.camel@joe-AO725>	 <20140602181658.GX22231@linux.vnet.ibm.com> <20140602185635.GB13569@cloud>	 <20140602190821.GZ22231@linux.vnet.ibm.com> <20140602191155.GB13648@cloud>	 <20140602192729.GB22231@linux.vnet.ibm.com> <1401737782.7323.31.camel@joe-AO725>
In-Reply-To: <1401737782.7323.31.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 12:36 PM, Joe Perches wrote:
> On Mon, 2014-06-02 at 12:27 -0700, Paul E. McKenney wrote:
>> On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
>>>
>>> I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
>>> as reviewers as well, with their consent.
>>
>> Mathieu, Oleg, Lai, any objections?
> 
> I suggest not going overboard with R entries.
> If there are more than 1 or 2, create a mailing list.

Yes, much better on the patch sender(s) to Cc: 1 or 2 people or lists
than to have to copy/paste 5 or 6 email addresses.

> And more entries will just make the churn and name-decay
> in MAINTAINERS that much more prevalent.
> 
> None of those people have any significant
> quantities of commit entries for rcu

-- 
~Randy
