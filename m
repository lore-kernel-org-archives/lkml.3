Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaC3Bgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:36:33 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39393 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaC3Bgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:36:31 -0400
Date: Sat, 29 Mar 2014 18:36:28 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: David Decotigny <decot@googlers.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Weilong Chen <chenweilong@huawei.com>, Jiri Pirko <jiri@resnulli.us>,
        Amir Vadai <amirv@mellanox.com>, Michael Dalton <mwdalton@google.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH net-next v2] net-sysfs: expose number of carrier on/off
 changes
Message-ID: <20140329183628.509f1239@nehalam.linuxnetplumber.net>
In-Reply-To: <2fd338e34d809af14353a03bc1edd0935f332faf.1396111568.git.decot@googlers.com>
References: <cover.1396111568.git.decot@googlers.com>
	<2fd338e34d809af14353a03bc1edd0935f332faf.1396111568.git.decot@googlers.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2014 09:48:35 -0700
David Decotigny <decot@googlers.com> wrote:

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

Is there a related SNMP MIB variable? should there be?


