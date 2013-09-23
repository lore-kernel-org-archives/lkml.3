Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3IWMcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:32:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17292 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3IWMcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:32:53 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-87-524034f3c82d
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] DT: S5P: If detected device tree skip irq init
Date: Mon, 23 Sep 2013 14:32:40 +0200
Message-id: <1623257.C2BrDo7kio@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379931222-29307-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379931222-29307-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7qfTRyCDKbPUrOYtO4Ak0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mdfi9JpTzBZrj9xld+D0aGnuYfP4u+oFs8fmJfUe
	B9/tYfLo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujLsTTzMWdLBWHFh9gbWBcSpLFyMnh4SA
	icScVe1sELaYxIV764FsLg4hgaWMElf/vWWFcLqYJHbc72IGqWITUJP43PAIrENEwFTi3d1r
	YB3MAj8YJdbtmw9WJCzgLLH191N2EJtFQFWiYdpDRhCbV0BTYvq8W2A1/ALqEu+2PWUCsUUF
	XCU+LdwIVs8p4C/x//RtsBohAT+J1w/vM0H0Ckr8mHwP7GxmAXmJffunskLYWhLrdx5nmsAo
	OAtJ2SwkZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIbX3YwLj5mdYhRgINR
	iYc3ItE+SIg1say4MvcQowQHs5II7yJFhyAh3pTEyqrUovz4otKc1OJDjEwcnFINjEY3ejm2
	+zVzH4ybMpHxuE6Had0mbclEwz0leqds0lhumN7Zu66Ou2CS0ZuTv9deDN7O/ud/tOCqiV1N
	plJHD34qcl978WTxFqGtM1kCmjZU3RTS5U04oztL9BVL5uSlf35bpT45N33OrGU7HFc0How6
	mjdJ0k+vTEtbIDGJj+mg7aGCoD/sD5RYijMSDbWYi4oTAYWEOxtrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 of September 2013 12:13:42 Mateusz Krawczuk wrote:
> It prevents from executing code already called by device tree.

I'd say that it prevents from executing code handling things that, when 
booting with device tree, are already handled by other code, namely the 
pinctrl-exynos driver.

> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/plat-samsung/s5p-irq-eint.c | 4 ++++
>  1 file changed, 4 insertions(+)

Otherwise, after fixing commit message:

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

