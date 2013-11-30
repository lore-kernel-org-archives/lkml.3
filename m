Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab3K3Rqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:46:39 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:49625 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3K3Rqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:46:37 -0500
Date: Sat, 30 Nov 2013 18:46:35 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Miller <davem@davemloft.net>
Cc: kamala@aristanetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: ip6_pkt_prohibit(_out) should not depend on CONFIG_IPV6_MULTIPLE_TABLES
Message-ID: <20131130174635.GK24171@order.stressinduktion.org>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	kamala@aristanetworks.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1385629923-22920-1-git-send-email-kamala@aristanetwors.com> <20131128190411.GD24171@order.stressinduktion.org> <20131129.163930.203685593163996122.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131129.163930.203685593163996122.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 04:39:30PM -0500, David Miller wrote:
> From: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Date: Thu, 28 Nov 2013 20:04:11 +0100
> 
> > Since patch "IPv6: Fixed support for blackhole and prohibit routes" we
> > need ip6_pkt_prohibit(_out) available without CONFIG_IPV6_MULTIPLE_TABLES
> > defined.
> > 
> > Cc: Kamala R <kamala@aristanetworks.com>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> 
> Please reference the SHA1 ID of the change as well as it's commit
> header text, thank you.

This patch is a follow-up patch for the first one in this thread which is not
committed, yet. Either Kamala can squash them into one or I'll repost it
later.

Greetings,

  Hannes

