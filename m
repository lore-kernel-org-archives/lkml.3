Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3DRTdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:33:13 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40414 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3DRTdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:33:11 -0400
Message-ID: <1366313588.3205.76.camel@edumazet-glaptop>
Subject: Re: Bonding driver has bad load balancing for forwarded traffic,
 3.7+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: vitalyb@telenet.dn.ua, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, fubar@us.ibm.com, linux@8192.net
Date: Thu, 18 Apr 2013 12:33:08 -0700
In-Reply-To: <20130418.150910.1780951630545456624.davem@davemloft.net>
References: <516C075E.30105@telenet.dn.ua>
	 <1366072679.4459.113.camel@edumazet-glaptop>
	 <1366081404.4459.127.camel@edumazet-glaptop>
	 <20130418.150910.1780951630545456624.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 15:09 -0400, David Miller wrote:

> Applied and queued up for -stable, but:
> 
> > +						sizeof(_l4), &_l4);						
>                                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> That's some rather amazing trailing whitespace.  Are you trying to break
> free of earth's atmosphere? :-)

Ah, sorry for this ;)

Thanks


