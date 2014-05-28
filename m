Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaE1Enc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:43:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22011 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaE1En2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:43:28 -0400
X-AuditID: cbfee690-b7fb56d000003439-81-5385696e123b
Message-id: <5385696E.60002@samsung.com>
Date: Wed, 28 May 2014 13:43:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, broonie@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH V2] extcon: arizona: support inverted jack detect switch
References: <20140520115632.GA13900@opensource.wolfsonmicro.com>
 <20140523115446.GA20451@opensource.wolfsonmicro.com>
In-reply-to: <20140523115446.GA20451@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkWDcvszXY4OIaA4tN16+zWtz/epTR
	4vKuOWwWtxtXsFksf/ufzWLWxD8sFqe7WR3YPe5c28PmMe9koMfLib/ZPPq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugStjzfJTrAV7mCuOX21mbmB8xdTFyMkhIWAi8WTnO3YIW0ziwr31bF2M
	XBxCAksZJW5MWsMKU3R2zSMwW0hgOqNE+xMXiKLXjBINKy6CdfMKaEj8uXaGGcRmEVCVuPJ7
	DSOIzSagJbH/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UEzCUW37zDCjKUWWAJo8TSS1fBmoUF
	fCS2zmhjhthcLtF5bC3Y2ZwCjhILnj4Hs5kFdCT2t05jg7DlJTavecsMMkhC4By7xI/Wv4wQ
	FwlIfJt8CGgbB1BCVmLTAWaIzyQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0otM
	9IoTc4tL89L1kvNzNzECo+70v2cTdjDeO2B9iDEZaOVEZinR5Hxg1OaVxBsamxlZmJqYGhuZ
	W5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyO/lIrIboGHl30uai69IS0y
	J4rFX9LFbXH6zIufLH7OW33z9aNf4sGzH8XclDtxWPfY2imTj4qqbDC831AislZfocYmXz/m
	7Kxferfydqzf9GJxharQQoawlbGH75+8deVOebGLjdFjr6jPIT466wuNa9hCux4wSAsa5BpV
	tMw7Ovl+gP25OaeVWIozEg21mIuKEwEx7gJ30AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd28zNZgg99zNC02Xb/OanH/61FG
	i8u75rBZ3G5cwWax/O1/NotZE/+wWJzuZnVg97hzbQ+bx7yTgR4vJ/5m8+jbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGWuWn2It2MNccfxqM3MD4yum
	LkZODgkBE4mzax6xQthiEhfurWcDsYUEpjNKtD9x6WLkArJfM0o0rLjIDpLgFdCQ+HPtDDOI
	zSKgKnHl9xpGEJtNQEti/4sbYM2iAmESK6dfYYGoF5T4MfkemC0iYC6x+OYdVpChzAJLGCWW
	XroK1iws4COxdUYbM8TmconOY2vBruMUcJRY8PQ5mM0soCOxv3UaG4QtL7F5zVvmCYwCs5Ds
	mIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP6mfQOxlUNFocYBTgYlXh4
	DyxuCRZiTSwrrsw9xCjBwawkwvsnoDVYiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJJucD001e
	SbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBuOhF0LGRhX5pc
	jdOhNO+zf6qm1z1Iv7dt9l2OBYG3vHa0TnL55zSV40TsQWvD5gSG57n6k/+0TBOU1lG5tT/6
	p7Rx+koVpn1PGraeqNrofrh7Decfc3PmRN70dyovuk//iUm3v8/D/eC18n15geIzDXX7RB9n
	Zdxin5P8+JS7OcOau88Xv16qxFKckWioxVxUnAgA+At+Hy0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 08:54 PM, Richard Fitzgerald wrote:
> Add config option for inverted jack detect switch that
> opens when jack is inserted.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c   |   34 ++++++++++++++++++++++++++--------
>  include/linux/mfd/arizona/pdata.h |    3 +++
>  2 files changed, 29 insertions(+), 8 deletions(-)

Applied.

Thanks,
Chanwoo Choi

