Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3KFAHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:07:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10834 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab3KFAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:07:03 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-f4-5279882460e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>
Cc: "'Kamil Debski'" <k.debski@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>, "'Felipe Balbi'" <balbi@ti.com>,
        "'Julius Werner'" <jwerner@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
 <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
 <527744B2.4090303@ti.com> <030d01ced946$d6e23490$84a69db0$%debski@samsung.com>
 <52779D28.9000905@ti.com>
 <CAFp+6iH7vQ-OtMFL4pyr4tFDRchH4oh1Z0753WNgrHiUzj+kzw@mail.gmail.com>
 <00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
 <000001ceda17$f41c2030$dc546090$%han@samsung.com>
 <000101ceda1f$04ca6f20$0e5f4d60$%han@samsung.com>
 <CAFp+6iFAZab35F-MOOZHcHpzSEOL=51gWBK2KZbOJS+0731GJQ@mail.gmail.com>
In-reply-to: <CAFp+6iFAZab35F-MOOZHcHpzSEOL=51gWBK2KZbOJS+0731GJQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Wed, 06 Nov 2013 09:07:00 +0900
Message-id: <000301ceda84$1d648bf0$582da3d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7aUJ5lhAcbritMRc+dhBvZawuOOQAMraHw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t8zI12Vjsogg4tH9CwO3q+3mH/kHKtF
	25WD7BZvv29ht2hevJ7N4vLCS6wWHYceM1n8eH2BzaJ3wVU2iwtPe9gsNj2+xmqxsG0Ji8Xl
	XXPYLGac38dksWhZK7PF4TftrBbrZ7xmcRD0mN1wkcVj56y77B77565h99i8pN6jb8sqRo/j
	N7YzeXzeJBfAHsVlk5Kak1mWWqRvl8CV8ffSLdaCVvaKJ9cuMTYwtrB2MXJySAiYSOxqf84M
	YYtJXLi3ng3EFhJYxihx6psTTM3TUysYuxi5gOKLGCX+PWmBcn4xShx8/wJsEpuAmsSXL4fZ
	QWwRAT2Jac3zwIqYBT6xSGz9cpwNomMhi8SczQfAdnAKBEvcfrCHEcQWFnCRaNx+CcxmEVCV
	uPn1EQuIzStgK7FnzyU2CFtQ4sfke2BxZgEtifU7jzNB2PISm9e8BfqBA+hWdYlHf3UhjjCS
	WDXzKyNEiYjEvhfvwA6SEDjAIbHu7hl2iF0CEt8mH2KB6JWV2HQAGhSSEgdX3GCZwCgxC8nm
	WUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihCSNCTsY7x2wPsSYDLR+
	IrOUaHI+MOnklcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAPj0nc9af85J542vVhlfb5lcrsqt6VrubT8wf8e8psibKyeJ2bf4UzkfRAxR8/pWZut
	x8rmE/sn/nkac9K48vNb/+yLqcYHHCfyXdlvvk7lPEtelUIYA3vj1c03Ow/8Czn0u1vv4PVF
	znqR0Ty3Zraf7RHeWX704a6bGk9LPvwSufi5mE9i8wUXJZbijERDLeai4kQAI/TtnDADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jAV2Vjsogg9Z9GhYH79dbzD9yjtWi
	7cpBdou337ewWzQvXs9mcXnhJVaLjkOPmSx+vL7AZtG74CqbxYWnPWwWmx5fY7VY2LaExeLy
	rjlsFjPO72OyWLSsldni8Jt2Vov1M16zOAh6zG64yOKxc9Zddo/9c9ewe2xeUu/Rt2UVo8fx
	G9uZPD5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wB+kBJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPH30i3Wglb2
	iifXLjE2MLawdjFyckgImEg8PbWCEcIWk7hwbz1bFyMXh5DAIkaJf09aGCGcX4wSB9+/AOtg
	E1CT+PLlMDuILSKgJzGteR5YEbPAJxaJrV+OQ7UvZJGYs/kAG0gVp0CwxO0He8B2CAu4SDRu
	vwRmswioStz8+ogFxOYVsJXYs+cSG4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3jJ3MXIA3aou
	8eivLsQRRhKrZn5lhCgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJEZyUnkntYFzZYHGIUYCDUYmHN0G+MkiINbGsuDL3EKMEB7OSCK9SHFCI
	NyWxsiq1KD++qDQntfgQYzLQoxOZpUST84EJM68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGCetW1r74ur8+K/GGq0pdgZZUrxFFQlnjH02ux+LL+MvqF2U
	KbPXof2W1zvLAr5NJXPUuE9ejnln49ibf7uiP1lmo6llqM/UV2+sD7ydHvy/ZT1v4flS46ca
	R45F/2YvkirVs7Pc9/TElb0VN9t1b3J8WqRXzrW4v/JOdNN6f9X8U4sfuHxYocRSnJFoqMVc
	VJwIAI/zNY+OAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 06, 2013 2:58 AM, Vivek Gautam wrote:
> On Tue, Nov 5, 2013 at 5:33 PM, Jingoo Han <jg1.han@samsung.com> wrote:

[.....]

>> USB3.0 PHY consists of two blocks such as 3.0 block and 2.0 block.
>> This USB3.0 PHY can support UTMI+ and PIPE3 interface for 3.0 block
>> and 2.0 block, respectively.
>>
>> Conclusion:
>>
>>    1) USB2.0 PHY: USB2.0 HOST, USB2.0 Device
>>                        Base address: 0x1213 0000
>>
>>    2) USB3.0 PHY: USB3.0 DRD (3.0 HOST & 3.0 Device)
>>                        Base address: 0x1210 0000
>>                        2.0 block(UTMI+) & 3.0 block(PIPE3)
>
> And this is of course the PHY used by DWC3 controller, which works at
> both High speed as well as Super Speed.
> Right ?

Right.

While 3.0 block(PIPE3) can be used for Super Speed, 2.0 block(UTMI+)
can be used for High speed.

Best regards,
Jingoo Han

