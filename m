Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab3CZCxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:53:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27089 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3CZCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:53:37 -0400
X-IronPort-AV: E=Sophos;i="4.84,909,1355126400"; 
   d="scan'208";a="32429301"
Message-ID: <ed19f23c22d5a92cda8e3622060bed61.squirrel@www.codeaurora.org>
In-Reply-To: <1363872898.1390.143.camel@x61.thuisdomein>
References: <1363872898.1390.143.camel@x61.thuisdomein>
Date: Mon, 25 Mar 2013 19:53:37 -0700
Subject: Re: [PATCH] arch: remove CONFIG_GENERIC_FIND_NEXT_BIT again
From: rkuo@codeaurora.org
To: "Paul Bolle" <pebolle@tiscali.nl>
Cc: "Richard Kuo" <rkuo@codeaurora.org>, "Jonas Bonn" <jonas@southpole.se>,
        linux-hexagon@vger.kernel.org, linux@openrisc.net,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CONFIG_GENERIC_FIND_NEXT_BIT was removed in v3.0, but reappeared in two
> architectures. Remove it again.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
>
> 1) See commit 63e424c84429903c92a0f1e9654c31ccaf6694d0 ("arch: remove
> CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}") for the removal of this
> Kconfig symbol.
>
> 2) Sent as one patch. Feel free to tell me to split it up in two
> patches.
>
>  arch/hexagon/Kconfig  | 3 ---
>  arch/openrisc/Kconfig | 3 ---
>  2 files changed, 6 deletions(-)
>

I'd be fine pulling these into my tree to go with my next batch of
changes, or the OpenRISC folks can if they want.  Ack would be nice.

Just in case:

Acked-by: Richard Kuo <rkuo@codeaurora.org>


Thanks,
Richard Kuo



--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


