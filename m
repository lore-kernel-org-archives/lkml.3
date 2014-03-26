Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaCZArb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:47:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaCZAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:47:29 -0400
Date: Tue, 25 Mar 2014 20:47:28 -0400 (EDT)
Message-Id: <20140325.204728.2281772666453524010.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140325.204343.991901655152875043.davem@davemloft.net>
References: <1395434633-16771-1-git-send-email-haiyangz@microsoft.com>
	<216cd74854414cfc9b338cab41a3d1a0@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140325.204343.991901655152875043.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 17:47:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 25 Mar 2014 20:43:43 -0400 (EDT)

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 25 Mar 2014 20:37:43 +0000
> 
>> Do we know when the dependency (commit: 8a7206a89f) will be merged
>> into net-next tree?
> 
> You're really not very patient, to say the least.
> 
> It's done now and I'm working to integrate your patch.
> 
> That patch has been in under review state in patchwork, which means
> that I will get to it at some point, so you don't need to worry about
> it any more than any other patch you might submit.
> 
> The whole reason patchwork exists is so that people don't have to
> ask.

And actually, this dependency "8a7206a89f" commit doesn't exist
in the 'net' tree at all.  I just merged Linus's tree into 'net'
and it doesn't exist there either.

So this patch still doesn't compile.

I'm tossing it from patchwork until you sort this out.
