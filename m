Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3JKPCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:02:20 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:55685 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JKPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:02:18 -0400
Date: Fri, 11 Oct 2013 17:02:17 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Oussama Ghorbel <ou.ghorbel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Initialize ip6_tnl.hlen in gre tunnel even if no route is found
Message-ID: <20131011150216.GA18601@order.stressinduktion.org>
Mail-Followup-To: Oussama Ghorbel <ou.ghorbel@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1381427427-14880-1-git-send-email-ou.ghorbel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381427427-14880-1-git-send-email-ou.ghorbel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 06:50:27PM +0100, Oussama Ghorbel wrote:
> The ip6_tnl.hlen (gre and ipv6 headers length) is independent from the
> outgoing interface, so it would be better to initialize it even when no
> route is found, otherwise its value will be zero.
> While I'm not sure if this could happen in real life, but doing that
> will avoid to call the skb_push function with a zero in ip6gre_header
> function.
> 
> Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Thanks,

  Hannes

