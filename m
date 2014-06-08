Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaFHUCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:02:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbaFHUCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:02:14 -0400
Message-ID: <5394C131.8010404@redhat.com>
Date: Sun, 08 Jun 2014 22:01:53 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
Subject: Re: [PATCH 6/7] lib/random32.c: Randomize timeout to the millisecond,
 not the second
References: <20140608124212.2653.qmail@ns.horizon.com>
In-Reply-To: <20140608124212.2653.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 02:42 PM, George Spelvin wrote:
>> Note, when you talk about efficiency here, this is called once every
>> 40+ secs ... ;)
>
> Agreed, in this case the code size saving (avoid a function call) is the
> main benefit.  And I prefer to avoid inefficiency on general priinciples,
> if it's not serving some other goal.

Hm, don't think it will make much of a difference.
