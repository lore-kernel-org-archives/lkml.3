Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaJGOet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:34:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54471 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaJGOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:34:47 -0400
Message-ID: <1412692484.11091.123.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: RE: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Lothar =?ISO-8859-1?Q?Wa=DFmann=27?=" <LW@KARO-electronics.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 07 Oct 2014 07:34:44 -0700
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174C60B1@AcuExch.aculab.com>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
	 <063D6719AE5E284EB5DD2968C1650D6D174C6025@AcuExch.aculab.com>
	 <20141007161702.7cd1e800@ipc1.ka-ro>
	 <063D6719AE5E284EB5DD2968C1650D6D174C60B1@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 14:23 +0000, David Laight wrote:

> The point I was making is that if you have to do a read-write of the received
> data (to byteswap it) then you might as well always copy it into a new skb that
> is just big enough for the actual receive frame.

+1


