Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936464Ab3DKPdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:33:21 -0400
Received: from 1wt.eu ([62.212.114.60]:32826 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934954Ab3DKPdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:33:20 -0400
Date: Thu, 11 Apr 2013 17:32:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Soeren Moch <smoch@web.de>, Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Dale Farnsworth <dale@farnsworth.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
Message-ID: <20130411153256.GH1910@1wt.eu>
References: <1365684023-9967-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130411131333.GD1910@1wt.eu> <CABJ1b_TQDabT1J7ffo5cb1Th=71bcSduifMJaDpfVRiiHvtWDw@mail.gmail.com> <20130411150326.GA19978@1wt.eu> <CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 05:27:03PM +0200, Sebastian Hesselbarth wrote:
> I don't have a strong opinion on whether Soeren's or your proposal should
> be submitted. But I insist on having one of them in, as GRO significantly
> improves the common use case, is enabled by default, and not as
> constrained as LRO.

I agree, use yours first, but we should keep an eye on this. Since you have
everything to run a test, please try to see if you can get netperf to run
over IPv6, I'm sure the NIC doesn't handle it.

Willy

