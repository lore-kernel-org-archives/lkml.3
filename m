Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3LLBXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:23:22 -0500
Received: from one.firstfloor.org ([193.170.194.197]:43722 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLBXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:23:19 -0500
Date: Thu, 12 Dec 2013 02:23:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christian Grothoff <grothoff@in.tum.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, knock@gnunet.org, jacob@appelbaum.net
Subject: Re: [PATCH] TCP: add option for silent port knocking with
 integrity protection
Message-ID: <20131212012317.GL21717@two.firstfloor.org>
References: <52A75EF8.3010308@in.tum.de>
 <20131211.150137.368953964178408437.davem@davemloft.net>
 <52A8C8B4.4060109@in.tum.de>
 <20131211122637.75b09074@nehalam.linuxnetplumber.net>
 <87bo0nulkt.fsf@tassilo.jf.intel.com>
 <52A8ECF5.3070604@in.tum.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A8ECF5.3070604@in.tum.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... and then do the same for the first TCP packet with payload? And you

That gets passed through by the firewall rule.

> seriously would consider that "safer" or "less error prone", starting

Yes the risk of adding exploitable holes to the kernel is signficantly
lower.

-Andi
