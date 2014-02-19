Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaBSTiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:38:05 -0500
Received: from na6sys009bog035.obsmtp.com ([74.125.150.109]:37173 "HELO
	na6sys009bog035.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755015AbaBSTiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:38:01 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 14:38:01 EST
MIME-Version: 1.0
In-Reply-To: <20140218.181507.1046967430290052114.davem@davemloft.net>
References: <fee7d53a1cfdec0aec7ea35a1f2f4b5e66766ee3.1392750899.git.joe@perches.com>
	<20140218.181507.1046967430290052114.davem@davemloft.net>
Date: Wed, 19 Feb 2014 11:32:41 -0800
Message-ID: <CALnjE+rvh7Rqpw1expkhJtRGt7Quy8MVWkUVfjVh4BsPaj2jVg@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next] openvswitch: Use ether_addr_copy
From: Pravin Shelar <pshelar@nicira.com>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse is on vacation. So I applied it to ovs master.

Thanks.

On Tue, Feb 18, 2014 at 3:15 PM, David Miller <davem@davemloft.net> wrote:
> From: Joe Perches <joe@perches.com>
> Date: Tue, 18 Feb 2014 11:15:45 -0800
>
>> It's slightly smaller/faster for some architectures.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> I'll let Jesse take this via his tree, thanks Joe.
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> http://openvswitch.org/mailman/listinfo/dev
