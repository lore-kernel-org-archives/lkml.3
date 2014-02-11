Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBKQlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:41:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:37927 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752460AbaBKQlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:41:08 -0500
Date: Tue, 11 Feb 2014 17:41:05 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of
 of_find_matching_node_and_match
Message-ID: <20140211174105.7a2ad23b@skate>
In-Reply-To: <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
	<1392135847-30791-5-git-send-email-joshc@codeaurora.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Josh Cartwright,

On Tue, 11 Feb 2014 10:24:02 -0600, Josh Cartwright wrote:
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

Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
