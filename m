Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaCaUZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:25:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42875 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaUZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:25:23 -0400
Date: Mon, 31 Mar 2014 16:25:19 -0400 (EDT)
Message-Id: <20140331.162519.2285405045402915587.davem@davemloft.net>
To: decot@googlers.com
Cc: jhs@mojatatu.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, edumazet@google.com, ebiederm@xmission.com,
        chenweilong@huawei.com, jiri@resnulli.us, amirv@mellanox.com,
        mwdalton@google.com, viro@ZenIV.linux.org.uk, tj@kernel.org
Subject: Re: [PATCH net-next v2] net-sysfs: expose number of carrier on/off
 changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <2fd338e34d809af14353a03bc1edd0935f332faf.1396111568.git.decot@googlers.com>
References: <cover.1396111568.git.decot@googlers.com>
	<2fd338e34d809af14353a03bc1edd0935f332faf.1396111568.git.decot@googlers.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Mar 2014 13:25:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Sat, 29 Mar 2014 09:48:35 -0700

> This allows to monitor carrier on/off transitions and detect link
> flapping issues:
>  - new /sys/class/net/X/carrier_changes
>  - new rtnetlink IFLA_CARRIER_CHANGES (getlink)
> 
> Tested:
>   - grep . /sys/class/net/*/carrier_changes
>     + ip link set dev X down/up
>     + plug/unplug cable
>   - updated iproute2: prints IFLA_CARRIER_CHANGES
>   - iproute2 20121211-2 (debian): unchanged behavior
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

Looks good, applied, thanks David.
