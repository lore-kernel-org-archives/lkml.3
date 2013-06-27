Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3F0LuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:50:18 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51344 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3F0LuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:50:16 -0400
Message-ID: <1372333818.3301.226.camel@edumazet-glaptop>
Subject: Re: [BUG]: missing shinfo with netlink_alloc_large_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 04:50:18 -0700
In-Reply-To: <20130627114432.GA22103@cpv436-motbuntu>
References: <20130627114432.GA22103@cpv436-motbuntu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 15:44 +0400, Artem Savkov wrote:
> Hello,
> 
> I ran into a bug while running trinity with write/writev syscalls. Seems like
> it has been introduced by "netlink: allow large data transfers from user-space"
> commit. nf_fib_input calls skb_clone which expects skb_shinfo to be allocated,
> but netlink_alloc_large_skb doesn't do that, should it?.
> Relevant dmesg log below.
> 

Yes, this was discussed and Pablo is working on it

http://marc.info/?l=linux-netdev&m=137232186620827&w=2


