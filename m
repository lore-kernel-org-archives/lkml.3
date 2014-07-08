Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaGHPqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:46:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51085 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGHPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:46:23 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c7-53bc124c0a08
Message-id: <53BC122C.9090505@samsung.com>
Date: Tue, 08 Jul 2014 17:45:48 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kishon@ti.com, dianders@chromium.org,
        gautam.vivek@samsung.com, spk.linux@gmail.com
Subject: Re: [PATCH 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
References: <1404118582-21993-1-git-send-email-sachin.kamat@samsung.com>
In-reply-to: <1404118582-21993-1-git-send-email-sachin.kamat@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xa7o+QnuCDX6cYbI4u+wgm0XblYPs
	Fhee9rBZXN41h81ixvl9TBZXLp1is2j5eo7Fgd1jdsNFFo+ds+6ye/RtWcXocfzGdiaPz5vk
	AlijuGxSUnMyy1KL9O0SuDL2TPjDVLCFqaLl+nu2BsafjF2MnBwSAiYS/5YfZoOwxSQu3FsP
	ZHNxCAksZZTo3dcDViQk8JlRoueLOojNK6Al0T5jLROIzSKgKnFp6T6wZjYBNYnPDY/AbH6g
	mjVN11m6GDk4RAUiJB5fEIJoFZT4MfkeC4gtIuAp8evUUTCbWaBGYnX3V7BWYQFfiWONP1kh
	1npIrGtYzAxicwLVX9q8jhWiXkdif+s0NghbXmLzmrfMExgFZyFZMQtJ2SwkZQsYmVcxiqaW
	JhcUJ6XnGuoVJ+YWl+al6yXn525ihIT+lx2Mi49ZHWIU4GBU4uHVqN0dLMSaWFZcmXuIUYKD
	WUmE98spoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGuuwfV6KzrRvjmOJK3qe9+nFshqzhpC/H
	zosvnTrN3nV+zJ79W/UbLsQfnqfTv1y1421jX/q9lQrc72Y+FDGwedEzI+/z0epHHd4ZTqL+
	X1Mtvbdsc5tTWjv99KSDVxp8jU/vjbqibdOx+SDDRotm5jsvWBoPs8d9LW/WSajwyIuX4D94
	4MQnJZbijERDLeai4kQA8vjJUFsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.06.2014 10:56, Sachin Kamat wrote:
> Since the USB 2.0 PHYs are required only with EHCI/OHCI USB drivers,

That's not true. They are also required for USB gadget controller
supported by the DWC2 gadget driver (formerly s3c-hsotg). Otherwise the
change makes sense to me.

Best regards,
Tomasz
