Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab3FSLxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:53:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52050 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab3FSLxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:53:07 -0400
X-AuditID: cbfee68f-b7f436d000000f81-0c-51c19ba13df6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <20130619164521.f5477ccb559cc6c6f8b0a19a@canb.auug.org.au>
In-reply-to: <20130619164521.f5477ccb559cc6c6f8b0a19a@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the samsung tree with the usb tree
Date: Wed, 19 Jun 2013 20:53:05 +0900
Message-id: <1f6801ce6ce3$8f1b7380$ad525a80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5suJdjhnWgqBQ1RV+QrcmQbVel8gAKtfDg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ92Fsw8GGiz4rW3xd9IxdotzC2Yw
	WpxtesNucXnXHDaLgwvbGC227r3KbrF+xmsWB3aP378mMXo03rjB5vH2YYBH35ZVjB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZfRcvcFS8Im5Ys/z+6wNjJ3MXYycHBICJhJfH3YzQthiEhfurWfr
	YuTiEBJYxijx6+IqFpiijvvT2SES0xklnl5YDFX1l1Hi8sdDYKPYBDQkDr9/xg5iiwjoSvT9
	m88EUsQscI5RYsPaHWBFQgJuEku+nWIFsTkF3CUmNU1mArGFBbwlXp64DFbDIqAq0fH0NFic
	V8BWYu+TTihbUOLH5HtgJzELaEms33mcCcKWl9i85i1QLwfQqeoSj/7qgpgiAkYSL7vlISpE
	JPa9eMcIco6EwFt2iaUbL7JArBKQ+Db5EAtEq6zEpgPQUJGUOLjiBssERolZSBbPQrJ4FpLF
	s5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJHr7dzDePWB9iDEZaP1EZinR5Hxg
	9OeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVHt
	RO/izXZle6+d/GEbffNMZLzFl5jpqziTt/u6sz+xU//wNWEuz4bZW14qGTexGDF1a6baSeQo
	S5jrTg+9WzRR8NRvva3q5V8MlFTWNYS8Wz6/dfuZ1yEXp9bkL/96k2H+p5XhzIfsp06oiXhj
	/G2/cqCP+FbXyduuN+R+nqB3yIFXxMts+WolluKMREMt5qLiRAB66Yz09AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd2Fsw8GGvxu1rD4O+kYu8W5BTMY
	Lc42vWG3uLxrDpvFwYVtjBZb915lt1g/4zWLA7vH71+TGD0ab9xg83j7MMCjb8sqRo/Pm+QC
	WKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWb0XL3BUvCJuWLP8/usDYyd
	zF2MnBwSAiYSHfens0PYYhIX7q1n62Lk4hASmM4o8fTCYijnL6PE5Y+HwDrYBDQkDr9/BtYh
	IqAr0fdvPhNIEbPAOUaJDWt3gBUJCbhJLPl2ihXE5hRwl5jUNJkJxBYW8JZ4eeIyWA2LgKpE
	x9PTYHFeAVuJvU86oWxBiR+T77GA2MwCWhLrdx5ngrDlJTaveQvUywF0qrrEo7+6IKaIgJHE
	y255iAoRiX0v3jFOYBSahWTQLCSDZiEZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwanhmdQOxpUNFocYBTgYlXh4G1YeCBRiTSwrrsw9xCjBwawkwlsx82CgEG9KYmVValF+
	fFFpTmrxIcZkoD8nMkuJJucD01ZeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NT
	C1KLYLYwcXBKNTCWK3eEylVHKd3Z5rrv4S2hDV+v6mq+uXP/niif47XdmtM2PzSUu8VRF1K6
	9shF6Xvei4t572YYz+NdNWM6g+3rmF1O1QVnAjebNJ5T1L7g57dI9f1pToccI4WDD8/o6U+w
	1msJ+TXzwWdnT+8tK9ImqTy/8vjoDpUFC34lHGOtffvvwdXeM/wflFiKMxINtZiLihMBNdHo
	x1EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi,

> Today's linux-next merge of the samsung tree got a conflict in
> drivers/usb/Kconfig between commit d9ea21a77927 ("usb: host: make
> USB_ARCH_HAS_?HCI obsolete") from the usb tree and commit 58d5b72088cc
> ("USB: Check for ARCH_EXYNOS separately") from the samsung tree.
> 
> I fixed it up (USB_ARCH_HAS_EHCI is no longer used) and can carry the fix
> as necessary (no action is required).
> 
Looks good to me, thanks.

- Kukjin

