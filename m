Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3LRAyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:54:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14051 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3LRAyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:54:35 -0500
X-AuditID: cbfee68e-b7fb46d00000186a-a2-52b0f24abb4a
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com, jg1.han@samsung.com,
        galak@codeaurora.org, matt.porter@linaro.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-4-git-send-email-k.debski@samsung.com>
 <006a01cef551$7fb4e240$7f1ea6c0$%tikhomirov@samsung.com>
 <02d201cefb2b$9e04e710$da0eb530$%debski@samsung.com>
In-reply-to: <02d201cefb2b$9e04e710$da0eb530$%debski@samsung.com>
Subject: RE: [PATCH v4 3/9] phy: Add new Exynos USB PHY driver
Date: Wed, 18 Dec 2013 09:54:33 +0900
Message-id: <001701cefb8b$b78a8ea0$269fabe0$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7xtb/TcbT2JoEKQI6IBVag+SxyjgDmHfwwAXcg4IAAF/4yMA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zQ12vTxuCDBp/sljMP3KO1aL/zUJW
	i7YrB9ktLi+8xGrx4/UFNosLT3vYLM42vQGK7ZrDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFue3dDJZHH7TzmqxfsZrFouOswfZHQQ9Lvf1MnnsnHWX3ePOtT1sHn1bVjF6HL+xncnj
	8ya5ALYoLpuU1JzMstQifbsEroz/234xFhxgrzj2fD9jA+ML1i5GTg4JAROJRfPOQdliEhfu
	rWfrYuTiEBJYxigx7dFMJpiiy8feMkMkFjFKLJ49kxkkISTwj1Fix/wAEJtNwEji5cGNYEUi
	AksZJb7PgShiFrjNJHHnhS9E90dGibc328HGcgo4Smy7t5oFxBYWsJM4v72LEcRmEVCVaGy4
	zAZi8wq4SMzd+poVwhaU+DH5HgvEUD2Jj39uM0LY8hKb14CcxwF0qrrEo7+6IGERASeJ530/
	oErEJSY9eMgOcoOEwAEOieWrFrBC7BKQ+Db5EAtEr6zEpgPMEB9LShxccYNlAqPELCSbZyHZ
	PAvJ5llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJEZIu+nYw3jxgfYgxGWj9RGYp
	0eR8YLrJK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MuufPCKyYeu9kod8Wp4Sk3kuRDZb/w8+Y8F3e0dK/d3Ubm9KWuRoJjgp7vYJbmCKzG/uf
	ObVtXTX385wgGZ6HeX+OCs/0E8/uZTb9WuhiM9PpjIZNrsRy1lvX7pk8vrlqOU+/x9WySoad
	L4UyHs/5vlrVpD+Uh+fhosDKi9VKOkfMomfx8BcrsRRnJBpqMRcVJwIA8D6EWi0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAV3PTxuCDNbstLGYf+Qcq0X/m4Ws
	Fm1XDrJbXF54idXix+sLbBYXnvawWZxtegMU2zWHzWLG+X1MFouWtTJbrD1yl93ibP9tNouJ
	TdPYLc5v6WSyOPymndVi/YzXLBYdZw+yOwh6XO7rZfLYOesuu8eda3vYPPq2rGL0OH5jO5PH
	501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUDnKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz/m/7xVhwgL3i2PP9
	jA2ML1i7GDk5JARMJC4fe8sMYYtJXLi3nq2LkYtDSGARo8Ti2TPBEkIC/xgldswPALHZBIwk
	Xh7cyAxSJCKwlFHi+xyIImaB20wSd174QnR/ZJR4e7OdCSTBKeAose3eahYQW1jATuL89i5G
	EJtFQFWiseEyG4jNK+AiMXfra1YIW1Dix+R7LBBD9SQ+/rnNCGHLS2xeA3IqB9Cp6hKP/uqC
	hEUEnCSe9/2AKhGXmPTgIfsERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRnIyeSe1gXNlgcYhRgINRiYeXY/b6ICHWxLLiytxDjBIczEoivDvvbQgS4k1J
	rKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgoswriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBkYLs39fQ7j2fI3W2mdixxVROCdk6/UMtXzbSEG9u4t+50VkCN6V
	sOOXZSldciJ0vdP+nNP+105P0/mc7nfzH8O790Vnbyh5bBbfv27ups26efbdoVylLKlhEr8s
	ZTgervo60yooT+P78+dJE75GG1wvDQmYuD6au9umKDcs6Z/ur82XGRQneCixFGckGmoxFxUn
	AgAKrD+bigMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,

> Hi Anton,
> 
> > From: Anton Tikhomirov [mailto:av.tikhomirov@samsung.com]
> > Sent: Tuesday, December 10, 2013 3:43 AM
> >
> > Hi Kamil,
> >
> > Same USB2.0 PHY may be used by several HCDs, for example EHCI and
> OHCI.
> > Consider the situation, when EHCI stops using the PHY and calls
> > power_off, then OHCI becomes non-operational. In other words, PHY
> > power_on and power_off calls must be balanced.
> >
> > Shall we handle it in your driver? (usage count?)
> 
> Please look in the drivers/phy/phy-core.c file. Usage count is handled
> there - see phy_power_on and phy_power_off functions. I understand that
> after both EHCI and OHCI power on the phy, the usage count is 2. So
> powering off one of them (EHCI for instance) the usage count is still
> 1, so the OHCI should still work properly.

Oops, sorry, missed that.

> 
> [snip]
> 
> Best wishes,
> --
> Kamil Debski
> Samsung R&D Institute Poland

