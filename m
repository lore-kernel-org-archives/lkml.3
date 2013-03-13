Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3CMORh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:17:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52834 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab3CMORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:17:32 -0400
X-AuditID: cbfee68d-b7f786d000005188-86-51408a7b36fd
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Chris Ball'" <cjb@laptop.org>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Will Newton'" <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
 <1361546283-7479-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1361546283-7479-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH v4] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Wed, 13 Mar 2013 23:17:30 +0900
Message-id: <002101ce1ff5$7f713fe0$7e53bfa0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4RD+VURbLeELfvQJ2BVgR5JeDssAO4wDyw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zA93qLodAg75jTBZ/Jx1jt9j+eiOb
	xY1fbawWl3fNYbM48r+f0eLkn15Gi2MzljBa7Hu8htniT99OFgdOj9+/JjF67Jx1l92jZ+cZ
	Ro9DV9Yyety5tofNo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDKuvXzNWPCNqaLjdDtbA+N2
	pi5GTg4JAROJpSu/skDYYhIX7q1n62Lk4hASWMYosXHaQ0aYoivLFrBDJKYzSjR8/cIM4fxh
	lHjfsIcNpIpNQEvi75s3zCC2iICaROPfTlaQImaBtUwS658eBUsICVRKbFzXBraPU8BJYvWB
	t0ArODiEBdwlPp/zADFZBFQl1hw3BqngFbCVmLJ5CwuELSjxY/I9MJtZwEDi/aw+VghbXmLz
	mrfMIK0SAuoSj/7qQlxgJHHh+FxGiBIRiX0v3jGCXCMh0MshMa/lPNjJLAICEt8mH2KB6JWV
	2HSAGeJfSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS
	83M3MUKivHcH4+0D1ocYk4HWT2SWEk3OByaJvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwmkc8Y/iZrKY+9ZP66dUu3MWTT/y03r5iq5Oa2Bme
	4ubdZ7f9mGee58vRslLMyW7DuVMTLglwxkak/fpTu/RG66Z/Fqe/z1jedd5zQmfUJ//5K6av
	2T9n+pyuM4zcLae2qsr6ZgZ+lvkr9WaT4B6tZcJB3kIRb+xU9XJsVslu2mepvEHw0I5VkUos
	xRmJhlrMRcWJAJKk3rQIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jQd2qLodAg/6fVhZ/Jx1jt9j+eiOb
	xY1fbawWl3fNYbM48r+f0eLkn15Gi2MzljBa7Hu8htniT99OFgdOj9+/JjF67Jx1l92jZ+cZ
	Ro9DV9Yyety5tofNo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4BuU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12Nk
	gAYS1jFmXHv5mrHgG1NFx+l2tgbG7UxdjJwcEgImEleWLWCHsMUkLtxbz9bFyMUhJDCdUaLh
	6xdmCOcPo8T7hj1sIFVsAloSf9+8YQaxRQTUJBr/drKCFDELrGWSWP/0KFhCSKBSYuO6NhYQ
	m1PASWL1gbeMXYwcHMIC7hKfz3mAmCwCqhJrjhuDVPAK2EpM2byFBcIWlPgx+R6YzSxgIPF+
	Vh8rhC0vsXnNW2aQVgkBdYlHf3UhLjCSuHB8LiNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRl
	ASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgFPJMagfjygaLQ4wCHIxKPLwCX+0DhVgT
	y4orcw8xSnAwK4nwLs91CBTiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGB6yyuJNzQ2MTOy
	NDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRrmNf3leHOnOM+jbc1Py6LSP
	L/bw/Jpz/lLIRrt6+W8//Cs2c6VGBa7V3f/dKfzO7XcO8svvc/JFW1xgunA8Sj439buktXfD
	3vZp/PueP1iepdo7i099tfrv03/nCBu/zLSMjEk4XNhSczL+E2dkckZWh/cDj5aczKc9Rw5v
	F5hcdbd3F9dmNiWW4oxEQy3mouJEAIaXWjNlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013, Dongjin Kim wrote:
> This patch adds the compatible string for MSHC controller of Exynos4412.
> And exynos5250_dwmmc_caps is renamed to exynos_dwmmc_caps, since it has the
> capablities of common feature supported by Exynos4 and Exynos5.
> 
> Cc: Seungwon Jeon <tgih.jun@samsung.com>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

