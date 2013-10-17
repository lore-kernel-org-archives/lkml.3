Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3JQMsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:48:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25892 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3JQMsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:48:12 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-d2-525fdc8a13a0
Message-id: <525FDC87.1050402@samsung.com>
Date: Thu, 17 Oct 2013 14:48:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: spi-s3c64xx: Add missing pm_runtime_put on setup fail
References: <1382013941-861-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1382013941-861-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7pdd+KDDOZO5LKYtO4Ak8XUh0/Y
	LF6/MLToXXCVzWLT42usFpd3zWGzmHF+H5NF48eb7A4cHn9XvWD22LSqk81j85J6j74tqxg9
	Pm+SC2CN4rJJSc3JLEst0rdL4Mq4tXYre8EhpoquryeYGhgnMXUxcnJICJhIvGj6xwphi0lc
	uLeerYuRi0NIYCmjxMVly6CcT4wSf18sZgGp4hXQkng37QYjiM0ioCox6fE/MJtNwFCi92gf
	mC0qECZxtOknK0S9oMSPyfdYQAaJCMxmlJj6Zw0jiMMs0MYocfT5JqAVHBzCAv4S985ZgzQI
	CbhKnHy/ngUkzCngJvHpQx5ImFlAR2J/6zQ2CFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGK
	ppYmFxQnpeca6RUn5haX5qXrJefnbmKEBPvXHYxLj1kdYhTgYFTi4Z2xPC5IiDWxrLgy9xCj
	BAezkgjvlu3xQUK8KYmVValF+fFFpTmpxYcYmTg4pRoYN/c/6o5ey9xx73HxzhesDycrTfFS
	VjsYzW2+fKan0Mo0p1N/z83Ys3j2S/NbX9mufrVSMxZhnOcYyiCluX5C4q41brr1z59YsBRy
	7JjR8GuupKR70vqLU9d9MQ1r2cC6T2DqBqFblgW1z0P+7Dsq84cvslnQaMeWXZ77KgyOHZBs
	CPz38mBonxJLcUaioRZzUXEiAIpozwBUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/13 14:45, Krzysztof Kozlowski wrote:
> pm_runtime_put() wasn't called if clock rate could not be set up in
> s3c64xx_spi_setup() leading to invalid count of device pm_runtime usage.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
