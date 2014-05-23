Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaEWJV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:21:26 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38270 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaEWJVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:21:24 -0400
Message-ID: <537F130F.6080901@mentor.com>
Date: Fri, 23 May 2014 10:21:19 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kamal@canonical.com>,
        <bhutchings@solarflare.com>, <edumazet@google.com>, <mszeredi@suse.cz>,
        <fw@strlen.de>
Subject: Re: skbuff truesize incorrect.
References: <537E4AFD.20304@mentor.com>	<20140522.152146.2116142050088142989.davem@davemloft.net>	<537E5C63.7080607@mentor.com> <20140522.165833.414855217799383878.davem@davemloft.net>
In-Reply-To: <20140522.165833.414855217799383878.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 23 May 2014 09:21:22.0911 (UTC) FILETIME=[5D2F96F0:01CF7668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/14 21:58, David Miller wrote:
> From: Jim Baxter <jim_baxter@mentor.com>
> Date: Thu, 22 May 2014 21:21:55 +0100
> 
>> If there are multiple clones for an skb all pointing at the same data,
>> will that distort the memory used when they all have the same truesize?
> 
> What is distorted about it?
> 
> Each clone references exactly that much backing memory.
>

Thank you for you help, I think distorted was the wrong word.


I think I am confused what truesize is used for it looks like it is used
to deallocate memory, is this correct?


