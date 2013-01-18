Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ARTSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:18:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38568 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3ARTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:18:49 -0500
Date: Fri, 18 Jan 2013 14:18:48 -0500 (EST)
Message-Id: <20130118.141848.1960193352262628503.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony.cheneau@amnesiak.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2 2/2] 6lowpan: Handle uncompressed IPv6 packets over
 6LoWPAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358399388-30062-3-git-send-email-alan@signal11.us>
References: <1358315037-10043-1-git-send-email-alan@signal11.us>
	<1358399388-30062-1-git-send-email-alan@signal11.us>
	<1358399388-30062-3-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Thu, 17 Jan 2013 00:09:48 -0500

> Handle the reception of uncompressed packets (dispatch type = IPv6).
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Applied.
