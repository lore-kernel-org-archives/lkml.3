Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429Ab3JPVsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:48:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38221 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760758Ab3JPVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:48:35 -0400
Message-ID: <525F09B0.4080802@infradead.org>
Date: Wed, 16 Oct 2013 14:48:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 16 (net/sched/em_ipset.c)
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381949500-501-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/13 11:51, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131016 tag is also provided for convenience.
> 
> Gained two new conflicts, but nothing too exciting. x86 and ARM default
> configurations as well as the x86 allmodconfig mostly build fine on the
> final tree. There was a failure for the ARM at91x40_defconfig, but the
> proper fix wasn't immediately obvious to me, so I've left it broken for
> now.

on i386, when CONFIG_NET_NS is not enabled:

net/sched/em_ipset.c: In function 'em_ipset_change':
net/sched/em_ipset.c:27:36: error: 'struct net_device' has no member named 'nd_net'
net/sched/em_ipset.c: In function 'em_ipset_destroy':
net/sched/em_ipset.c:49:34: error: 'struct net_device' has no member named 'nd_net'


-- 
~Randy
