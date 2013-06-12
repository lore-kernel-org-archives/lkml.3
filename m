Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3FLBQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:16:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52815 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3FLBQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:16:18 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-2d-51b7cbe0efc8
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "=?UTF-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'Mike Turquette'" <mturquette@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
References: <201306111328.52679.heiko@sntech.de>
 <201306111330.28759.heiko@sntech.de>
In-reply-to: <201306111330.28759.heiko@sntech.de>
Subject: RE: [PATCH v3 3/7] mmc: dw_mmc-pltfm: move probe and remove below dt
 match table
Date: Wed, 12 Jun 2013 10:16:15 +0900
Message-id: <000901ce670a$6f96a2c0$4ec3e840$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5mly9NIa8kgW8ARzasDJ60btVztwAB8vcw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t8zI90Hp7cHGmy8rWDxcsJhRou/k46x
	W2x/vZHN4sDsh6wWB/7sYLT4/+g1q8WNX22sFlP+LGey2PT4GqvF5V1z2CyO/O9ntLh9mdfi
	6YSLbBanrn9mszi84gCTxdMHTUwOAh4tzT1sHr9/TWL0WPD5CrvHk00XGT12zrrL7nHoylpG
	jzvX9rB5bF5S73F+xkJGjysnmlg9+rasYvTYfm0es8fnTXIBvFFcNimpOZllqUX6dglcGQ+v
	rWcueMJU0XG8soFxAVMXIyeHhICJxILr51kgbDGJC/fWs3UxcnEICSxjlNi35j0zTNG79W9Y
	IBKLGCUWLLgOVfWHUWLn57VsIFVsAloSf9+8AesQEYiT+D9vPjtIEbPADhaJK1t+sIIkhATC
	JSYtfcwIYnMKGEpc+bIWzBYWiJaY+XsamM0ioCrx7OlcsHpeAVuJs8f2skHYghI/Jt8Du5VZ
	QF1i0rxFzBC2tsSTdxeA6jmATlWXePRXF+IGI4lJ+ydAlYtI7HvxjhHkHgmBJxwSN2e2s0Hs
	EpD4NvkQC0SvrMSmA1AfS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSo
	V5yYW1yal66XnJ+7iRGSZHp3MN4+YH2IMRlo/URmKdHkfGCSyiuJNzQ2M7IwNTE1NjK3NCNN
	WEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9yzjRoyDFs3v7h4dOFhRp37NdlT
	tGs+7Zkc4RamKVdnm7hatv6IcvoF+U31HWE7yjaZtfVwrZBOOTMxZ4n6XO54v0/tezbG+rA9
	dk95YX6moJ6TZ9OBlapCzkKtNmJPSo67V6r9OqKtnt99N4fnhN1vt+M6T2rma5z6EXu357/4
	xusLA7NuKrEUZyQaajEXFScCABKRYnxIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsVy+t9jAd0Hp7cHGtw/Im3xcsJhRou/k46x
	W2x/vZHN4sDsh6wWB/7sYLT4/+g1q8WNX22sFlP+LGey2PT4GqvF5V1z2CyO/O9ntLh9mdfi
	6YSLbBanrn9mszi84gCTxdMHTUwOAh4tzT1sHr9/TWL0WPD5CrvHk00XGT12zrrL7nHoylpG
	jzvX9rB5bF5S73F+xkJGjysnmlg9+rasYvTYfm0es8fnTXIBvFENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QK8pKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwnrGDMeXlvPXPCEqaLjeGUD4wKmLkZODgkBE4l369+wQNhiEhfu
	rWfrYuTiEBJYxCixYMF1KOcPo8TOz2vZQKrYBLQk/r55wwxiiwjESfyfN58dpIhZYAeLxJUt
	P1hBEkIC4RKTlj5mBLE5BQwlrnxZC2YLC0RLzPw9DcxmEVCVePZ0Llg9r4CtxNlje9kgbEGJ
	H5PvgZ3ELKAuMWneImYIW1viybsLQPUcQKeqSzz6qwtxg5HEpP0ToMpFJPa9eMc4gVFoFpJJ
	s5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKewZ1I7GFc2WBxiFOBg
	VOLhPWC2PVCINbGsuDL3EKMEB7OSCK9uLlCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84Hp
	Na8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGE8nH/htJ8J5
	R7308/qI/P9nv4tv2W0rtq+s0/zDs75nG8xOdfz51+wVtaK/19XEzMVHmlmAmeFp3ZasbWsj
	5dmeL1XMrrkoX712i8neN5pKq4/Krmqr9lvGIcVoksGvKnD605EDLS0GlzQFneT3rdrn42K/
	gc2T6yvLq/gH4oKTTs3q2ht5S4mlOCPRUIu5qDgRAIlH2lClAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 2013 8:30 PM Heiko Stübner wrote:
> In a subsquent patch probe will need to do some handling of data from
> the dt match table. So to prevent the need for forward declarations,
> move probe and remove below the match table.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>


