Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3L3SK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:10:28 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33899 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3L3SK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:10:26 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/11] mac80211: use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 10:10:10 -0800 (PST)
Message-ID: <1458346.msaUrcf9Zq@debian64>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc4-wl+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1388427307-8691-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr> <1388427307-8691-4-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: p54: use ether_addr_equal_64bits

On Monday, December 30, 2013 07:14:59 PM you wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Ether_addr_equal_64bits is more efficient than ether_addr_equal, and can be
> used when each argument is an array within a structure that contains at
> least two bytes of data beyond the array.
> 
> The structures involved are:
> ieee80211_hdr defined in include/linux/ieee80211.h and
> p54_common defined in drivers/net/wireless/p54/p54.h
> 
> This was done using Coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Alright, I changed the subject to "p54: ..." (John, can you do that, or do
you want another patch?). Since this has not much to do with mac80211. 

Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Regards,

Christian
