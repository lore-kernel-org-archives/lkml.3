Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbaGOW5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:57:49 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33101 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaGOW5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:57:47 -0400
Message-ID: <53C5B1F7.3000409@gmail.com>
Date: Tue, 15 Jul 2014 18:57:59 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: josh@joshtriplett.org
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com> <1405463509-2468-2-git-send-email-bobby.prani@gmail.com> <20140715225313.GB24290@cloud>
In-Reply-To: <20140715225313.GB24290@cloud>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/15/2014 06:53 PM, josh@joshtriplett.org wrote:
> On Tue, Jul 15, 2014 at 06:31:48PM -0400, Pranith Kumar wrote:
>> This commit removes a stale comment in rcu/tree.c.
>> FYI, an updated comment exists a few lines below this.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> In general, when removing a stale comment, I'd suggest explaining why
> the comment is stale.  Was code removed without removing the
> corresponding comment, or was code changed such that the comment no
> longer applies, or...?

I guess it was left out when code was moved around previously. And I did mention that an updated comment is there a few lines below.

For reference this is the new comment which is below the old comment, they mean the same :)

    /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
