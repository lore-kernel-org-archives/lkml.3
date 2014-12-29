Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaL2EvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 23:51:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36309 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaL2EvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 23:51:03 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-46-54a0ddb20cd3
Date: Mon, 29 Dec 2014 04:50:58 +0000 (GMT)
From: GIRISH K S <ks.giri@samsung.com>
Subject: Re: [PATCH 15/27] net: sxgbe: Use setup_timer
To: Julia Lawall <Julia.Lawall@lip6.fr>, ByungHo An <bh74.an@samsung.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Vipul Chandrakant <vipul.pandya@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: ks.giri@samsung.com
MIME-version: 1.0
X-MTR: 20141229044926733@ks.giri
Msgkey: 20141229044926733@ks.giri
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141229044926733@ks.giri
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <451468949.291671419828656924.JavaMail.weblogic@epmlwas09c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWyRsSkWnfT3QUhBq+3alpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M788OMhfME63o/DuVqYHxikgXIweHkICSxIVfQl2MnBwSAiYS
	RzunsUDYYhIX7q1n62LkAipZyihx/+oOFpiiV4/fskIk5jBKHDjUygaSYBFQlVj45jxYEZuA
	usTHA72MILawgJnEgh3NYLaIgL/EpusT2UGamQXeM0rM7ZnFDpIQEpCV+PXxKZjNKyAocXLm
	E6htChKHJnZCxRUlnnffZIWIy0ksmXqZCcLmlZjR/pQFJj7t6xpmCFta4vysDYww7yz+/hgq
	zi9x7PYOqF4BialnDkLVqEr8X3CQHcLmk1iz8C0LTP2uU8uZYXbd3zIXqldCYmvLE7B7mIFu
	m9L9kB3CNpA4smgOK7pfeAXcJWZv/sQC8ryEwEQOidaW7awTGJVmIambhWTWLCSzkNUsYGRZ
	xSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRGYHE7/ezZhB+O9A9aHGAU4GJV4eBNOLAgRYk0s
	K67MPcRoCoyoicxSosn5wBSUVxJvaGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxpQdTtG2VtN9Nxyq/H9Zj824Vpa13cNYXcQmvMzc5d0RvWez2z7G8X7M
	VT4Vmyjf/PB/2q9G4Xv7NRrDLjvtOLTY9oJk7sdenqebV33z8TYWft2pUHNBzvpyiY5u/vyk
	Y3Gt1450crvIW3aYvDln7/3hs9s76bZ93+/rFff8nLjLwvpRa5yzEktxRqKhFnNRcSIAPDjv
	pgkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t/tft1NdxeEGDQsV7K4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRnf
	nx1kLpgnWtH5dypTA+MVkS5GDg4hASWJC7+Euhg5OSQETCRePX7LCmGLSVy4t56ti5ELqGQO
	o8SBQ61sIAkWAVWJhW/Os4DYbALqEh8P9DKC2MICZhILdjSD2SIC/hKbrk9kB2lmFnjPKDG3
	ZxY7SEJIQFbi18enYDavgKDEyZlPWCC2KUgcmtgJFVeUeN59E+oKOYklUy8zQdi8EjPan7LA
	xKd9XcMMYUtLnJ+1gRHm6sXfH0PF+SWO3d4B1SsgMfXMQagaVYn/Cw6yQ9h8EmsWvmWBqd91
	ajkzzK77W+ZC9UpIbG15AnYPM9BtU7ofskPYBhJHFs1hRfcLr4C7xOzNn1gmMMrOQpKahaR9
	FpJ2ZDULGFlWMYqmFiQXFCelV5joFSfmFpfmpesl5+duYgQnomdLdjA2XLA+xCjAwajEw8tx
	bEGIEGtiWXFl7iFGCQ5mJRFeozKgEG9KYmVValF+fFFpTmrxIUZTYLRNZJYSTc4HJsm8knhD
	YxNzU2NTCwNDc3MzJXHe/+dyQ4QE0hNLUrNTUwtSi2D6mDg4pRoYGcMq+yx3rkxoE8gUdV3v
	YX/QzV07S6ckcrdr9grFmsqNf7YdCldWdhIs2pyz7NP1FRJB0098vXPQ/NkJ9m0bJB0bn1Ud
	Zr32/uU0X+mvumb+Mi2LbNhlak8t9M4WYS1n7NCYOPdETO3qTfeC1SIrDLbmLqgR3SfOWvlq
	hlpckFSmm9tD1dVKLMUZiYZazEXFiQDu9fgJWgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBT4pSGZ016580



------- Original Message -------
Sender : Julia Lawall<Julia.Lawall@lip6.fr>
Date : Dec 26, 2014 20:05 (GMT+05:30)
Title : [PATCH 15/27] net: sxgbe: Use setup_timer

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// 
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.function = f;
-t.data = d;
// 

Signed-off-by: Julia Lawall 

---
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c |   10 ++++------
1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 6984944..b6612d6 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -133,9 +133,8 @@ bool sxgbe_eee_init(struct sxgbe_priv_data * const priv)
return false;

priv->eee_active = 1;
- init_timer(&priv->eee_ctrl_timer);
- priv->eee_ctrl_timer.function = sxgbe_eee_ctrl_timer;
- priv->eee_ctrl_timer.data = (unsigned long)priv;
+ setup_timer(&priv->eee_ctrl_timer, sxgbe_eee_ctrl_timer,
+     (unsigned long)priv);
priv->eee_ctrl_timer.expires = SXGBE_LPI_TIMER(eee_timer);
add_timer(&priv->eee_ctrl_timer);

@@ -1009,10 +1008,9 @@ static void sxgbe_tx_init_coalesce(struct sxgbe_priv_data *priv)
struct sxgbe_tx_queue *p = priv->txq[queue_num];
p->tx_coal_frames =  SXGBE_TX_FRAMES;
p->tx_coal_timer = SXGBE_COAL_TX_TIMER;
- init_timer(&p->txtimer);
+ setup_timer(&p->txtimer, sxgbe_tx_timer,
+     (unsigned long)&priv->txq[queue_num]);
p->txtimer.expires = SXGBE_COAL_TIMER(p->tx_coal_timer);
- p->txtimer.data = (unsigned long)&priv->txq[queue_num];
- p->txtimer.function = sxgbe_tx_timer;
add_timer(&p->txtimer);
}
}
Looks good to me.
Acked by: Girish K S <ks.giri@samsung.com>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
