Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3IMQLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:11:35 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:49012 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3IMQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:11:34 -0400
Message-ID: <1379088687.2438.13.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH] [Trivial] remove unnecessary header file inclusion
From: Ben Hutchings <bhutchings@solarflare.com>
To: ZHAO Gang <gamerh2o@gmail.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 13 Sep 2013 17:11:27 +0100
In-Reply-To: <20130913145718.GA2536@will>
References: <20130913145718.GA2536@will>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20144.005
X-TM-AS-Result: No--4.908800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 22:57 +0800, ZHAO Gang wrote:
> file linux/fib_rules.h doesn't exist, so remove it.

Do you think people wouldn't notice #include of a nonexistent file?  gcc
is quite good at complaining about them...

It's now called include/uapi/linux/fib_rules.h.

Ben.

> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> ---
>  include/net/fib_rules.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
> index 4b2b557..c816f91 100644
> --- a/include/net/fib_rules.h
> +++ b/include/net/fib_rules.h
> @@ -4,7 +4,6 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/netdevice.h>
> -#include <linux/fib_rules.h>
>  #include <net/flow.h>
>  #include <net/rtnetlink.h>
>  

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


