Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3L3SLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:11:12 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:43450 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3L3SLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:11:09 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] carl9170: use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 19:10:58 +0100
Message-ID: <10609239.5b8Q6kF6b9@debian64>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc4-wl+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1388427307-8691-12-git-send-email-Julia.Lawall@lip6.fr>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr> <1388427307-8691-12-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 30, 2013 07:15:07 PM Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Ether_addr_equal_64bits is more efficient than ether_addr_equal, and can be
> used when each argument is an array within a structure that contains at
> least two bytes of data beyond the array.
> 
> The structures involved are:
> ieee80211_hdr defined in include/linux/ieee80211.h,
> ieee80211_bar defined in include/linux/ieee80211.h and
> ath_common defined in drivers/net/wireless/ath/ath.h
> 
> This was done using Coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
