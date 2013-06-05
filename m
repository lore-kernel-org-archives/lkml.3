Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3FEOAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:00:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61622 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3FEOA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:00:29 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-6b-51af447bbce8
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "=?utf-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de>
 <201306030058.27184.heiko@sntech.de>
In-reply-to: <201306030058.27184.heiko@sntech.de>
Subject: RE: [PATCH 05/10] mmc: dw_mmc-pltfm: remove static from
 dw_mci_pltfm_remove
Date: Wed, 05 Jun 2013 23:00:26 +0900
Message-id: <001501ce61f5$08043ba0$180cb2e0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5f6rmHeakN3Q+cR/6Q/0raPq9rSQB9qobA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t8zA91ql/WBBsva2Sz+TjrGbrH99UY2
	iwOzH7JaHPizg9Hi/6PXrBY3frWxWpz5rWsx5c9yJotNj6+xWlzeNYfN4sj/fkaL25d5LZ5O
	uMhmcer6ZzaLwysOMFls3jSV2UHAo6W5h83j969JjB4LPl9h9zh0ZS2jx51re9g83p07x+6x
	eUm9x/kZCxk9rpxoYvXo27KK0WP7tXnMHp83yQXwRHHZpKTmZJalFunbJXBl7Ft3hKVgBlNF
	29rj7A2Mzxm7GDk5JARMJOa+ucQMYYtJXLi3ng3EFhJYxijRvl4QpmbTjO9AcS6g+HRGieVf
	+pkhnD+MEk8udDOBVLEJaEn8ffMGbJKIQJzE/1uPWUCKmAXms0j8OjYLqIgDqCNcYvUSFRCT
	U8BQ4tdFe5ByYYEwiZalLWCLWQRUJRpfzWIHsXkFbCUWLjvEBGELSvyYfI8FpJVZQF1iypRc
	kDCzgLbEk3cXWEHCEkDhR391IQ4wkng36xcLRImIxL4X7xhBjpEQeMAhseHYE3aIVQIS3yYf
	YoHolZXYdAAaDJISB1fcYJnAKDELyeJZCItnIVk8C8mGBYwsqxhFUwuSC4qT0otM9IoTc4tL
	89L1kvNzNzFCEsqEHYz3DlgfYkwG2j6RWUo0OR+YkPJK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwNjc8Ojp8lVeUg9CrfZMlHYNWn/E62R8949z
	G0J8FndMn2Ipmfuq4wfL4rIbT98/0Eya/Prj0gCri20q5y0M9XSXxZrb3VpyaKKDjvcWrW8r
	1qR8v9Ui66baP/X+vDVLpM7PZ7j18YzggXXTFguWvcitvRQ99avbl1rVSUHy6movHzyXtuPw
	7OZXYinOSDTUYi4qTgQAQu4JnD4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xoG61y/pAgyW2Fn8nHWO32P56I5vF
	gdkPWS0O/NnBaPH/0WtWixu/2lgtzvzWtZjyZzmTxabH11gtLu+aw2Zx5H8/o8Xty7wWTydc
	ZLM4df0zm8XhFQeYLDZvmsrsIODR0tzD5vH71yRGjwWfr7B7HLqyltHjzrU9bB7vzp1j99i8
	pN7j/IyFjB5XTjSxevRtWcXosf3aPGaPz5vkAniiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jFm7Ft3hKVgBlNF29rj7A2Mzxm7GDk5JARMJDbN+M4GYYtJXLi3Hsjm4hAS
	mM4osfxLPzOE84dR4smFbiaQKjYBLYm/b94wg9giAnES/289ZgEpYhaYzyLx69gsoCIOoI5w
	idVLVEBMTgFDiV8X7UHKhQXCJFqWtoAtYxFQlWh8NYsdxOYVsJVYuOwQE4QtKPFj8j0WkFZm
	AXWJKVNyQcLMAtoST95dYAUJSwCFH/3VhTjASOLdrF8sECUiEvtevGOcwCg0C8mgWQiDZiEZ
	NAtJxwJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwenqmdQOxpUNFocYBTgYlXh4PzCs
	CxRiTSwrrsw9xCjBwawkwjvRYX2gEG9KYmVValF+fFFpTmrxIcZkoDcnMkuJJucDU2leSbyh
	sYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAu971dpZ3wSH1prkfi
	4WXN374GLDFiezpnxt7y/c12RvMk/Lds1D3mkX24YmVBG4PKF4O2R8ohOg+nOoUvdVa5vf/r
	f6mld0+dabFQDm3rnKjxpjuRhWm3iPN9pstva+NbvjOsip15r+ljdsTtpacuVW4q+WLRuWZH
	e2p4zU+pyN8BDNwydxcqsRRnJBpqMRcVJwIA1M87V5sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 2013 7:58 AM, Heiko Stübner wrote:
> dw_mci_pltfm_remove gets exported and used by dw_mmc-exynos, so should
> not be static.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

