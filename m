Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3LBPeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:34:37 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:53182 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3LBPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:34:34 -0500
Date: Mon, 2 Dec 2013 16:34:33 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Kamala R <kamala@aristanetworks.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4] IPv6: Fixed support for blackhole and prohibit routes
Message-ID: <20131202153433.GA3867@order.stressinduktion.org>
Mail-Followup-To: Kamala R <kamala@aristanetworks.com>,
	netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
References: <1385994322-23117-1-git-send-email-kamala@aristanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385994322-23117-1-git-send-email-kamala@aristanetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 07:55:21PM +0530, Kamala R wrote:
> The behaviour of blackhole and prohibit routes has been corrected by setting
> the input and output pointers of the dst variable appropriately. For
> blackhole routes, they are set to dst_discard and to ip6_pkt_discard and
> ip6_pkt_discard_out respectively for prohibit routes.
> 
> ipv6: ip6_pkt_prohibit(_out) should not depend on
> CONFIG_IPV6_MULTIPLE_TABLES
> 
> We need ip6_pkt_prohibit(_out) available without
> CONFIG_IPV6_MULTIPLE_TABLES
> 
> Signed-off-by: Kamala R <kamala@aristanetworks.com>

Looks good, thanks!

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

