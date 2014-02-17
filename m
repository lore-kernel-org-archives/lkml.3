Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaBQVct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:32:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51433 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBQVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:32:48 -0500
Date: Mon, 17 Feb 2014 16:32:45 -0500 (EST)
Message-Id: <20140217.163245.201722208746730259.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 0/3] Drivers: net: hyperv: Cleanup the hyper-V
 networking code 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392597483-13307-1-git-send-email-kys@microsoft.com>
References: <1392597483-13307-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2014 13:32:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sun, 16 Feb 2014 16:38:03 -0800

> Get rid of some unnecessary code and some general cleanup.
> 
> K. Y. Srinivasan (3):
>   Drivers: net: hyperv: Get rid of the rndis_filter_packet structure
>   Drivers: net: hyperv: Cleanup the receive path
>   Drivers: net: hyperv: Cleanup the netvsc receive callback functio

Series applied to net-next, thanks.
