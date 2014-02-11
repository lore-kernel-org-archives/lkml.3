Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBKRqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:46:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaBKRqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:46:00 -0500
Date: Tue, 11 Feb 2014 11:43:42 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of
 of_find_matching_node_and_match
Message-ID: <20140211174342.GD841@joshc.qualcomm.com>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
 <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
 <20140211165314.GA8533@titan.lakedaemon.net>
 <20140211181048.6934bdd3@skate>
 <52FA5E75.7030402@free-electrons.com>
 <20140211173446.GC27395@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211173446.GC27395@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:34:46PM -0500, Jason Cooper wrote:
> 
> Ok, great!  Josh, do you want us to take the two mvebu patches through
> mvebu/arm-soc?  Or would you prefer to take them?

Please, take them through the mvebu tree.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
