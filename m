Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3AXBKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:10:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44518 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3AXBKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:10:22 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-1b-510089fd4e27
Message-id: <51008A05.9030408@samsung.com>
Date: Thu, 24 Jan 2013 10:10:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] extcon: arizona: Disable debouce for accessory removal
 detection
References: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zPd2/nQyBBmdbOS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmt19LAVnmCuuzTnE2sD4nqmLkZNDQsBEon9zMyuELSZx4d56
	ti5GLg4hgWWMEu/fH2WEKbq9/jELRGIRo8TfaUtYIZxOJonJ+7+wg1TxCmhJnF/+D8jm4GAR
	UJU4cUICJMwGFN7/4gYbSFhUIELiVz8HRLWgxI/J91hAwiJA83/frwQJMwsUSMw72gG2Vlgg
	WmLG1n9gw4UEQiRals5nA7E5BUIlJh9czQRRryOxv3UaG4QtL7F5zVtmkMskBJrZJV7uX80M
	kmAREJD4NvkQ2C4JAVmJTQeYId6SlDi44gbLBEaxWUgumoVk7CwkYxcwMq9iFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECIkHqR2MKxssDjEKcDAq8fAqqDIECrEmlhVX5h5ilOBgVhLhVasH
	CvGmJFZWpRblxxeV5qQWH2JMBjpwIrOUaHI+MFbzSuINjQ2MDQ0tDc1MLU0NSBNWEudlPPUk
	QEggPbEkNTs1tSC1CGYLEwenVAOjgNoP3yMT/iVdDjPy6XOPTVj9YVWy0lrVO1Ih0nNMF+eG
	K27u3+Ah9r/qAP+M2R6VtgvYHzjf3X55stLkyCMTlxbrLrzWdOC76D/bn99ifmS5dR6b8vfO
	DcbO8rqlITd+tv3yevx+3c4EJja1vxEKGwwYF64OcN+31cdw+j32339nvN553mOdkxJLcUai
	oRZzUXEiABTdFTjLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAd2/nQyBBtv2M1lc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjDW7+1gKzjBXXJtziLWB
	8T1TFyMnh4SAicTt9Y9ZIGwxiQv31rN1MXJxCAksYpT4O20JK4TTySQxef8XdpAqXgEtifPL
	/wHZHBwsAqoSJ05IgITZgML7X9xgAwmLCkRI/OrngKgWlPgx+R4LSFgEaNfv+5UgYWaBAol5
	RzsYQWxhgWiJGVv/gQ0XEgiRaFk6nw3E5hQIlZh8cDUTRL2OxP7WaWwQtrzE5jVvmScwCsxC
	smEWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOtmdSOxhXNlgcYhTgYFTi
	4VVQZQgUYk0sK67MPcQowcGsJMKrVg8U4k1JrKxKLcqPLyrNSS0+xJgM9P5EZinR5HxgIsgr
	iTc0NjEzsjQyMzYxNzYmTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYwix2w37/KTa/hx
	itFht/HU9L/5gs4XZ8g6nvi9v707qyLDwikpYbXsPd1bp1n7b0Wr/OZRELm4yybWf2OLd1/A
	6YLOzsrXqs/n2qY38r9PCtmw3+DD4e7t333frHqT/00saNv088dL2w43FOzVaP1U8tnzjq3/
	0azZEpzrDAtX7DU/P+Wk3QElluKMREMt5qLiRACYu3UX+gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 01:03 AM, Mark Brown wrote:
> Ensure we clamp as quickly as possible after removal by disabling the
> debounce while there is an accessory present.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

Patches 1-4 applied.

Patch 5 failed to build, so I sent reply related to build error of Patch 5.

Thanks,
Chanwoo Choi
