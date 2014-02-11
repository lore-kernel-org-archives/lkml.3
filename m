Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaBKT3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:29:50 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60376 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754557AbaBKT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:29:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19s7aveNH19SrzZdW7MQGVJGQ2ZHBUntNY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8C6FB524CC8
Date: Tue, 11 Feb 2014 14:29:19 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of
 of_find_matching_node_and_match
Message-ID: <20140211192919.GH27395@titan.lakedaemon.net>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
 <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:24:02AM -0600, Josh Cartwright wrote:
> Instead of the of_find_matching_node()/of_match_node() pair, which requires two
> iterations through the match table, make use of of_find_matching_node_and_match(),
> which only iterates through the table once.
> 
> While we're here, mark the of_system_controller table const.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  arch/arm/mach-mvebu/system-controller.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Applied to mvebu/soc with Thomas' Reviewed-by, and Gregory's Ack.

thx,

Jason.
