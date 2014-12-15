Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaLOQsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:48:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43648 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLOQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:48:31 -0500
Date: Mon, 15 Dec 2014 11:48:29 -0500 (EST)
Message-Id: <20141215.114829.885744524649941189.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: sti: Fix uninitialized pointer
 dereference if !OF
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418642751-23308-1-git-send-email-geert@linux-m68k.org>
References: <1418642751-23308-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Dec 2014 08:48:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBFGmjt8032683

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 15 Dec 2014 12:25:51 +0100

> If CONFIG_OF is not set:
> 
> drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c: In function ¡sti_dwmac_parse_data¢:
> drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c:318: warning: ¡rs¢ is used uninitialized in this function
> 
> of_property_read_string() will return -ENOSYS in this case, and rs will
> be an uninitialized pointer.
> 
> While the fallback clock selection is already selected correctly in this
> case, the string comparisons should be skipped too, else the system will
> crash while dereferencing the uninitialized pointer.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
