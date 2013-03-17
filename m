Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3CQQlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:41:14 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:58306 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3CQQlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:41:11 -0400
Message-ID: <1363538008.29475.73.camel@edumazet-glaptop>
Subject: Re: BUG: IPv4: Attempt to release TCP socket in state 1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: dormando <dormando@rydia.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Sun, 17 Mar 2013 09:33:28 -0700
In-Reply-To: <alpine.DEB.2.02.1303170218460.28650@dflat>
References: <alpine.DEB.2.02.1303041547080.7811@localhost6.localdomain6>
	  <51356AC1.4090302@gmail.com> <1362460046.15793.111.camel@edumazet-glaptop>
	  <alpine.DEB.2.02.1303042138330.7811@localhost6.localdomain6>
	  <1362494795.15793.113.camel@edumazet-glaptop>
	 <alpine.DEB.2.02.1303061631290.6723@dflat>
	  <1362663990.15793.208.camel@edumazet-glaptop>
	  <alpine.DEB.2.02.1303141359080.16308@dflat>
	  <1363301786.29475.40.camel@edumazet-glaptop>
	  <alpine.DEB.2.02.1303141610490.16308@dflat>
	  <1363303174.29475.46.camel@edumazet-glaptop>
	 <1363455366.29475.66.camel@edumazet-glaptop>
	 <1363455885.29475.68.camel@edumazet-glaptop>
	 <alpine.DEB.2.02.1303170218460.28650@dflat>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 02:21 -0700, dormando wrote:

> Hope you don't mind a screenshot:
> http://www.dormando.me/p/3.8.2-trace-crash.jpg
> 
> (I put the patches on 3.8.2). box is on another continent so screenshot
> via IPMI is what I get. If this isn't enough or isn't right I'll try
> harder to get the trace logged, I guess?

Thanks a lot, this gives another useful input, no need for more traces
for the moment.

Could you send me the disassembly of tcp_release_cb() ?

(objdump -d vmlinux | filter to get tcp_release_cb() body)



