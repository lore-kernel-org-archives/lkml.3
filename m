Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaCFKZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:25:39 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33902 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaCFKZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:25:31 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-98-53184d183419
From: Kamil Debski <k.debski@samsung.com>
To: "'Tobias Jakobi'" <tjakobi@math.uni-bielefeld.de>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, stern@rowland.harvard.edu, sander@humilis.net
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com>
 <5317AE67.3040503@math.uni-bielefeld.de>
In-reply-to: <5317AE67.3040503@math.uni-bielefeld.de>
Subject: RE: [PATCH v9 0/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 11:25:26 +0100
Message-id: <193b01cf3926$6512dff0$2f389fd0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac84x9PL9cjT7r90RDCnXhVY3LjB4gAWN5PQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA02RW0iTYRzGeb/zRqOvuezFyIuB2UlT6fDSIiS6+AjS1JuoC1u6prBN21Kz
	bsbEQytPzMLmOfPA0mYfi0pjeMKRog410XK7MNMLN5NEtKyVn7vIu9/z8DwPf/gzuJQnwphM
	3V2VXqfUyCkxMRJwTUbBKzAl5mNjCHrRM0OihsExEpX7mkhUNNVHo8mmCRK5vz2m0KjJty27
	aylUPe7E0PPWQhx1DnpoNFr+hUKVpqc0Gnc8xNCAr5hE7d4eGlVsuSlkr14mUNHLVRKVjPbR
	8TJusqwU495bPTT3w9+Mc3PTHyguMERzNZ5NwJU5bIBzzbzFuDU+/Krouvh8ukqTmavSn7xw
	U5zR9TUpu42653/mpIwgQJgBw0D2FKx1qs1AtI2h0O21U2YgZqRsC4A/X38igsKIwdKWRVoo
	UOxRaPNygi9j7QCur5hoQeBsAw7nLE20MCVldfCNo2aHRexpWGW34AKHsBfh2tQaJjDBRsDP
	w/adjISNh531NhDkfXDT4t25DmcjYVWVVrBx9jhcWHGTwaMj4fyfKMGWsXGQL/lNByMy6DEu
	kRVAat01ZP0/ZN01ZN3VaASEDexX5aRlG26ptXHRBqXWkKNTR6dlaXkQ/PP6O9AydK4fsAyQ
	75F0JRxIkZLKXEO+th9ABpfLJI5YmCKVpCvz76v0Wan6HI3K0A8wRhRmBHXmZs3l7+5lV2PU
	jTvDdUxqz5NZUDchi+ZXPYecIybF2N5kLCLB4nJWtmUdGVhIntu4dKYg0Q8CikHcd4L8FVc/
	3edsTb1WGKO2/lXcnrdyxXzSqw1lxyNbvRhuNS+d7Q01hisSuxd5sS2vIO/g4ZWOkV4j8WBW
	5S/pNMkJQ4Yy9hiuNyj/Ae+c8iLFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

> From: Tobias Jakobi [mailto:tjakobi@math.uni-bielefeld.de]
> Sent: Thursday, March 06, 2014 12:08 AM
> 
> Hello Kamil,
> 
> this looks very good. I just tested the patchset on my ODROID-X2
> (Exynos4412-based board) and the USB stability issues I mentioned to
> you before (with the older patchset) seem to be gone.

This problem was related to the reset procedure not being done completely. 
It is corrected now.

> 
> All devices on the USB behave normally (mass storage, ethernet and
> bluetooth).

Thank you for testing these patches. Would you consider adding a "Tested-by" tag?
I am planning to send v10 soon, which will address comments to v9.

> 
> With best wishes,
> Tobias

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

