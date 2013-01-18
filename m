Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3ARTSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:18:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38561 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3ARTSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:18:44 -0500
Date: Fri, 18 Jan 2013 14:18:42 -0500 (EST)
Message-Id: <20130118.141842.1541240440239354147.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony.cheneau@amnesiak.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2 1/2] 6lowpan: Refactor packet delivery into a
 function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358399388-30062-2-git-send-email-alan@signal11.us>
References: <1358315037-10043-1-git-send-email-alan@signal11.us>
	<1358399388-30062-1-git-send-email-alan@signal11.us>
	<1358399388-30062-2-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Thu, 17 Jan 2013 00:09:47 -0500

> Refactor the handing of the skb's to the individual lowpan devices into a
> function.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Applied.
