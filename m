Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3LLTAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:00:47 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:51365 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LLTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:00:43 -0500
Date: Thu, 12 Dec 2013 20:00:42 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Miller <davem@davemloft.net>
Cc: vyasevich@gmail.com, dvlasenk@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, jpirko@redhat.com
Subject: Re: [patch net-next v2] ipv6: log autoconfiguration failures
Message-ID: <20131212190042.GH4675@order.stressinduktion.org>
Mail-Followup-To: David Miller <davem@davemloft.net>, vyasevich@gmail.com,
	dvlasenk@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
	jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
	jpirko@redhat.com
References: <52A99B56.1070503@redhat.com> <20131212.122241.2022824170198915190.davem@davemloft.net> <52A9F93A.5040104@gmail.com> <20131212.132441.1907656115241279246.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131212.132441.1907656115241279246.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 01:24:41PM -0500, David Miller wrote:
> From: Vlad Yasevich <vyasevich@gmail.com>
> Date: Thu, 12 Dec 2013 12:58:18 -0500
> 
> > On 12/12/2013 12:22 PM, David Miller wrote:
> >> Give it statistics just like we have for every other kind of similar
> >> event.
> > 
> > The fact that link-local address could not be generated for a specific
> > device type does not lend itself well to counting.  There is no way
> > from to tell from the counter which device does not support IPv6 autoconfig.
> 
> If the statistic is per-device, which I recommended it be implemented as,
> you indeed can.
> 
> And I do not buy the argument that this is "useless" because the admin
> is just going to kill the interface and create a new one.  When you
> notice there is a problem, you look at the statistics before doing
> that!

Granted.

IMHO both ways are fine with a slight opionion to counters being overkill. ;)

