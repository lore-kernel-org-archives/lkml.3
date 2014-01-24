Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaAXPxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:53:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50805 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaAXPxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:53:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-0b-52e28c663634
Message-id: <52E28C57.4060106@samsung.com>
Date: Fri, 24 Jan 2014 16:52:55 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: Re: [PATCH 7/8 v4] crypto:s5p-sss: validate iv before memcpy
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7ppPY+CDL7ulra4+/wwo8XLQ5oW
	3a9kLO7f+8lkcXnXHDaLGef3MVks2vaf2WLVrj+MFmfnHGJy4PTYOesuu8e2A6oefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlfF8wjbWgkXMFd9XvWFuYDzH1MXIySEhYCLRsfALK4QtJnHh
	3no2EFtIYCmjxO9l/F2MXED2Z0aJK69/gjXwCmhJPGndBVbEIqAqcWvnSrA4m4CaxOeGR2Bx
	UYEIib/z1jNC1AtK/Jh8jwXEFhEol/h3Yw0byFBmgTmMEg+XtIMlhAVcJR6/nskGsa2RUeLL
	rqXMIAlOATeJQ5/OgdnMAtYSKydtY4Sw5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hqaXJB
	cVJ6rqFecWJucWleul5yfu4mRkiwf9nBuPiY1SFGAQ5GJR7eGYEPg4RYE8uKK3MPMUpwMCuJ
	8O5sfRQkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdGmRpX17JGjEd2T53jt1ejhTCq/vv7d6qDI
	DnH1fZd3areE+6wUOfnnh9PhgPcLncxnn0nYFCm+h7WJZ4vPj7M1JXv08tTWuDUfM3bz3Mql
	cddKrLpD9oLFlxWJN1Lv2qhfm7vu8YR7zWc5xKO33yz3tZJ6c3ZL3QJuwe0r2vh+Ht9meOaW
	SLkSS3FGoqEWc1FxIgC2acjhVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2014 10:17, Naveen Krishna Chatradhi wrote:
> This patch adds code to validate "iv" buffer before trying to
> memcpy the contents
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v3:
> None
>
>   drivers/crypto/s5p-sss.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
