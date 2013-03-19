Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab3CSCDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:03:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17970 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab3CSCDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:03:42 -0400
X-AuditID: cbfee690-b7f656d0000007e3-90-5147c7766497
From: Jingoo Han <jg1.han@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ce2445$e1927be0$a4b773a0$%han@samsung.com>
In-reply-to: <000001ce2445$e1927be0$a4b773a0$%han@samsung.com>
Subject: [PATCH 2/2] extcon: max8997: add missing const
Date: Tue, 19 Mar 2013 11:03:33 +0900
Message-id: <000101ce2445$f61b7120$e2525360$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kRd0wUErczhqhS3ap06hUTXi3rAAAAezA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI92y4+6BBtPuKFhc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2Pm+SOsBdfYKu5NeMnawHiA
	tYuRg0NCwERi0uTMLkZOIFNM4sK99WxdjFwcQgLLGCWez7/DBpEwkdj6bzcjRGI6o8SeBXOY
	IZxfjBIL5nxnB6liE1CT+PLlMJgtIqAr8fLqbWYQm1kgT2LKkV1gtpCArcT9Nw1MIDangJ3E
	ve+/2UGuEBYwlzh03wskzCKgKnFyzjkWEJsXqPzItY+MELagxI/J91ggRmpJrN95nAnClpfY
	vOYtM8Qz6hKP/uqCmCICRhJ/P1lBVIhI7HvxDux8CYF97BKL969ghlglIPFt8iEWiFZZiU0H
	mCHelZQ4uOIGywRGiVlIFs9CsngWksWzkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93
	EyMk+ibsYLx3wPoQYzLQ+onMUqLJ+cDozSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY524wpIrMxynxL3iWn7vmoBs4UzbOVIhgpvPVjFlfpvR
	tv5WEFvsS/tLMwWvTIk+apZpcnDZ0enx8xs38C6c0njN9PyZfyvv+X/a2beirOv5G/EtM+7s
	Ptd5YKVdi5E38+N0J/ljn9P2b9vQxVCdUb3nysV19vVzn/tf+GS0Pfjuitw0i3+T+nYrsRRn
	JBpqMRcVJwIA45FbwNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd2y4+6BBq1fZSyuf3nOanF54SUg
	sWsOm8XtxhVsDiwefVtWMXp83iQXwBTVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA7RJSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYx5gx8/wR1oJrbBX3JrxkbWA8wNrFyMkhIWAisfXfbkYIW0ziwr31bF2MXBxCAtMZJfYs
	mMMM4fxilFgw5zs7SBWbgJrEly+HwWwRAV2Jl1dvM4PYzAJ5ElOO7AKzhQRsJe6/aWACsTkF
	7CTuff8NVM/BISxgLnHovhdImEVAVeLknHMsIDYvUPmRax8ZIWxBiR+T77FAjNSSWL/zOBOE
	LS+xec1bZpAxEgLqEo/+6oKYIgJGEn8/WUFUiEjse/GOcQKj0Cwkg2YhGTQLyaBZSFoWMLKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO7mdSOxhXNlgcYhTgYFTi4T0R7B4oxJpYVlyZ
	e4hRgoNZSYQ32B8oxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnAxJNXEm9obGJmZGlkZmFk
	Ym5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzOYRlH5s+UE1pUILv17AX7yv6E2zEb
	o+3zPkd7XF+SUNGfM3n+FP1NTyf2zomYNznsv3y67od44R9l4RadLzb8P858q7bkW6MyQ9hk
	JUOhXPeml2WzTmaEyAu88tnNVx4aw6xn9FZ4bpqOxv4ZrB9y/rPYGe1ZV6skxZ+62nHCz5ct
	FX+2yCmxFGckGmoxFxUnAgAXtkaeMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: static const char * array should probably be static const char * const
  #163: FILE: drivers/extcon/extcon-max8997.c:163:
  +static const char *max8997_extcon_cable[] = {

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 20772ad..6e8724f 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -160,7 +160,7 @@ enum {
 	_EXTCON_CABLE_NUM,
 };
 
-static const char *max8997_extcon_cable[] = {
+static const char const *max8997_extcon_cable[] = {
 	[EXTCON_CABLE_USB]			= "USB",
 	[EXTCON_CABLE_USB_HOST]			= "USB-Host",
 	[EXTCON_CABLE_TA]			= "TA",
-- 
1.7.2.5


