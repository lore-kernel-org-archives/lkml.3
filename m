Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaFPHcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:32:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaFPHco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:32:44 -0400
Message-ID: <539E9D93.9040405@redhat.com>
Date: Mon, 16 Jun 2014 09:32:35 +0200
From: Michal Privoznik <mprivozn@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed only when possible
References: <20140606085733.GJ2984@minipsycho.orion>	<20140606.125447.1665616708152334692.davem@davemloft.net>	<539AC237.40402@redhat.com> <20140613.130350.1729507484821351177.davem@davemloft.net>
In-Reply-To: <20140613.130350.1729507484821351177.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.2014 22:03, David Miller wrote:
> From: Michal Privoznik <mprivozn@redhat.com>
> Date: Fri, 13 Jun 2014 11:19:51 +0200
>
>> So if I were developing brand new application I could say: I'm
>> dropping all this workaround code and have it clean and require say
>> 3.16 kernel at least.
>
> Then your application wouldn't be usable on %99 of systems for a long
> long time.
>

How come? The application is going to be usable for as long as 
library/kernel APIs won't change. Or until the time a new regression is 
introduced and fix is rejected. Speaking of which - long long time 
applications *are* broken now. This patch is combining the good from 
both worlds: old applications are fixed, new applications doesn't have 
to learn anything new.

> I don't think this is the right tradeoff at all.
>

Neither is keeping things broken.

Michal
