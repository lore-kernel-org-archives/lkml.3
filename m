Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3CEOqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:46:40 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62928 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3CEOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:46:38 -0500
Message-ID: <1362494795.15793.113.camel@edumazet-glaptop>
Subject: Re: BUG: IPv4: Attempt to release TCP socket in state 1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: dormando <dormando@rydia.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Tue, 05 Mar 2013 06:46:35 -0800
In-Reply-To: <alpine.DEB.2.02.1303042138330.7811@localhost6.localdomain6>
References: <alpine.DEB.2.02.1303041547080.7811@localhost6.localdomain6>
	  <51356AC1.4090302@gmail.com> <1362460046.15793.111.camel@edumazet-glaptop>
	 <alpine.DEB.2.02.1303042138330.7811@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 21:44 -0800, dormando wrote:

> No 3rd party modules. There's a tiny patch for controlling initcwnd from
> userspace and another one for the extra_free_kbytes tunable that I brought
> up in another thread. We've had the initcwnd patch in for a long time
> without trouble. The extra_free_kbytes tunable isn't even being used yet,
> so all that's doing is adding a 0 somewhere.
> 
> Only two iptables rules loaded: global NOTRACK rules for PREROUTING/OUTPUT
> in raw.
> 
> Kernel's as close to pristine as I can make it. We had the 10g patch in
> but I've dropped it.
> --

Hmm, I spent time on this bug report but found nothing.

Please post as much information as you can on your setup.

I see you use macvlan, bridge, so maybe there is a configuration issue
(and a kernel bug of course)




