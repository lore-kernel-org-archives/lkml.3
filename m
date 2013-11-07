Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3KGL36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:29:58 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43188 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3KGL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:29:54 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-b4-527b79b056ba
From: Tomasz Figa <t.figa@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: Boot failure on Origen with next-20131107
Date: Thu, 07 Nov 2013 12:29:46 +0100
Message-id: <4908982.5yt51ejnyk@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <CAK9yfHz+H4FQpo_J0ycJP_rvRPMyDgXpZFvx+GvRjyywECUoCw@mail.gmail.com>
References: <CAK9yfHz+H4FQpo_J0ycJP_rvRPMyDgXpZFvx+GvRjyywECUoCw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xy7obKquDDN4eUrA48GcHo8XlXXPY
	LA4ubGO0OPmnl9GBxePOtT1sHp83yQUwRXHZpKTmZJalFunbJXBl7Nz7gqXgNWvFm1nPmBsY
	b7N0MXJySAiYSEydtIsNwhaTuHBvPZDNxSEksJRRYsrqNewQTheTxPPH59lBqtgE1CQ+NzwC
	6xAR0JJ42b2cCcRmFsiVOPbgDJgtLGAm8bp/EtgGFgFViY6edWBxXgFNiac/ZoLZ/ALqEu+2
	PQWzRQXcJKb/OMgMYnMKBEs82jsbLC4kECCx8PVJRoheQYkfk++xQOySl9i3fyorhK0lsX7n
	caYJjIKzkJTNQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghIfxlB+PiY1aH
	GAU4GJV4eGfUVAUJsSaWFVfmHmKU4GBWEuFtDqkOEuJNSaysSi3Kjy8qzUktPsTIxMEp1cAY
	7hy/h+GN3tTovDpnw7AfX9IS1Dn2v12Wzr7nYlFoo92/OafMy3/5Rnat7tt2eI23TL4x/4Ka
	CazH488/2B108oGD7d+ojJb8ip7a+cX75vkkOTUWnfT5KbxpTce9gp+9R1ovxWTfXMZV8sz0
	o/0MvpXvurxiuzobV+ecEQ65H7bw/ipbKzMlluKMREMt5qLiRACosj5oPwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Thursday 07 of November 2013 16:25:15 Sachin Kamat wrote:
> Hi,
> 
> Today's linux next fails to boot Origen (Exynos4210) board. However,
> Arndale (Exynos5250) board boots fine. Git bisect points to the
> following as bad commit:
> 
> 2361613206e66ce59cc0e08efa8d98ec15b84ed1 is the first bad commit
> commit 2361613206e66ce59cc0e08efa8d98ec15b84ed1
> Author: Grant Likely <grant.likely@linaro.org>
> Date:   Sun Sep 15 22:32:39 2013 +0100
> 
>     of/irq: Refactor interrupt-map parsing
> 
> Reverting gave several conflicts which I could not resolve with certainty.

This issue has been already fixed, but the fix has not yet been merged.

See: https://lkml.org/lkml/2013/11/5/255

Best regards,
Tomasz

