Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaKLD7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:59:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52965 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaKLBZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:34 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-90-5462b70c6cd8
Message-id: <5462B70B.5090400@samsung.com>
Date: Wed, 12 Nov 2014 10:25:31 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, cw00.choi@samsung.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH v2 2/5] regulator: rt5033: Add RT5033 Regulator device
 driver
References: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
 <1415603987-32475-3-git-send-email-beomho.seo@samsung.com>
 <20141110190403.GH3815@sirena.org.uk>
In-reply-to: <20141110190403.GH3815@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkSJdne1KIwZ2tUhZTHz5hs7j+5Tmr
	xfwj51gt/kxoZbOYdH8Ci8W3Kx1MFpd3zWGz+Nx7hNFixuSXbA6cHjtn3WX32LSqk82jb8sq
	Ro/Pm+QCWKK4bFJSczLLUov07RK4Mi7/a2cuuM1ScWXnVrYGxvvMXYwcHBICJhKTP3J2MXIC
	mWISF+6tZ+ti5OIQEljKKLFo1lw2iISJxM6pfSwQiUWMEu+ezWKCcF4zShxedI0FpIpXQEvi
	zOqbjCA2i4CqxJm3P5lAbDYBTYn3U66A1YgKREhcWTOHEaJeUOLH5HtgcREBZYmr3/eCbWAW
	uM8osWLTIrAiYYFgiQtPDjFDbFvNKLGn+RnYTZwCRhK9rzewgfzALKAncf+iFkiYWUBeYvOa
	t2D1EgK32CVmrLrEBHGRgMS3yYdYIH6Wldh0gBniNUmJgytusExgFJuF5KZZCFNnIZm6gJF5
	FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgBJ7+92zCDsZ7B6wPMQpwMCrx8CasSQoRYk0s
	K67MPcRoCnTERGYp0eR8YJznlcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBMVdWyiJJyHlWyZ71hvuEtdepPdzelZb98dsX3TcJO/qDyy4ozLuUWjN9
	tuuCBMN8vbJOr+DUJhfRL/vsm4uWrpiheHbvx9xTYabnra8J8Uu7bW8+EyvUpXz8Qprs3s4C
	o8LYr51fPry0vKJrqFpwcl4c64wLm69IdE87luUue1PlWN7xZ3yFSizFGYmGWsxFxYkASNir
	yrsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAV2e7UkhBo9OC1lMffiEzeL6l+es
	FvOPnGO1+DOhlc1i0v0JLBbfrnQwWVzeNYfN4nPvEUaLGZNfsjlweuycdZfdY9OqTjaPvi2r
	GD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx+V87c8Ftloor
	O7eyNTDeZ+5i5OSQEDCR2Dm1jwXCFpO4cG89WxcjF4eQwCJGiXfPZjFBOK8ZJQ4vugZWxSug
	JXFm9U1GEJtFQFXizNufTCA2m4CmxPspV8BqRAUiJK6smcMIUS8o8WPyPbC4iICyxNXve1lA
	hjIL3GeUWLFpEViRsECwxIUnh5ghtq1mlNjT/IwNJMEpYCTR+3oDkM0B1KEncf+iFkiYWUBe
	YvOat8wTGAVmIdkxC6FqFpKqBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/yZ1A7G
	lQ0WhxgFOBiVeHgT1ySFCLEmlhVX5h5ilOBgVhLhfbAUKMSbklhZlVqUH19UmpNafIjRFBgC
	E5mlRJPzgcknryTe0NjEzMjSyNzQwsjYXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDY9VU
	/6W528RLXDymTJI++P1v8J4sZ7EFL5k27qto2XjnvcbRI4dbr4XdeKjpnZH7Pf7UC3vRl2EC
	i6cvefE437nMdfVkQVnt0+KLdjhJzLpqa2m31yk8KW693wW+5n+PdFn+53qeet/9bJfnDtuY
	g8f5z0u67BK8er/wWu7DB+calb9cFb3Dp6PEUpyRaKjFXFScCADovyqOBgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I will include your e-mail address next revision all patch-set.

On 11/11/2014 04:04 AM, Mark Brown wrote:
> On Mon, Nov 10, 2014 at 04:19:44PM +0900, Beomho Seo wrote:
>> This patch add device driver of Richtek RT5033 PMIC.
>> The driver support multiple regulator like LDO and synchronous Buck.
>> The integrated synchronous buck converter is designed to provide 0.6 A
>> application with high efficiency. Two LDOs are integrated. One safe LDO is
>> for 60mA and the other one LDO is for 150 mA.
> 
> I'm missing all the other patches in this series...
> 

Regards,
Beomho Seo

