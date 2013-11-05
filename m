Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3KEPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:18:17 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26569 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KEPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:18:15 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c4-52790c35d117
From: Tomasz Figa <t.figa@samsung.com>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
Date: Tue, 05 Nov 2013 16:18:08 +0100
Message-id: <2177804.l4VGDTRFDu@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <20131104050455.GA3651@quad.lixom.net>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <20131101185401.B298FC40868@trevor.secretlab.ca>
 <20131104050455.GA3651@quad.lixom.net>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7qmPJVBBld6+Sw+NLUyW8w/co7V
	4sCfHYwWXw+vYLS4vGsOm8Wp65/ZHNg8et60sHrcubaHzePKiSZWj8+b5AJYorhsUlJzMstS
	i/TtErgyrp2dyFxwnbniastDlgbGL0xdjJwcEgImEp8617NA2GISF+6tZ+ti5OIQEljKKLHu
	WjszhNPFJDHtZycrSBWbgJrE54ZHbCC2iICyxJO2S8wgNrPAHUaJBYezQGxhAVuJadMngMVZ
	BFQlJi//ClbPK6ApsWDrR7A4v4C6xLttT8GuEBVwk5j+4yBYnFPAWGLy/B1QixczSqyae4kR
	ollQ4sfkeywQy+Ql9u2fygpha0ms33mcaQKj4CwkZbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFe
	cWJucWleul5yfu4mRkiwf9nBuPiY1SFGAQ5GJR7eB2fLg4RYE8uKK3MPMUpwMCuJ8B77XxEk
	xJuSWFmVWpQfX1Sak1p8iJGJg1OqgTF0wkTdf+t7cv8brWjqmGU6MT/esWtVaKyH/fdTxYfn
	KbrumpfT8WS/qu2SFPY638qF7+22m67riZlw2u3fweK2PRXTN6bwsU9x6oy/bDdpM+NEb9uI
	xZoLa/1lc+W5Yh5rdRusv5romXv0eGLnqTtXzPk291mH8OR8l0iWaQh8O+3a4sLpK5VYijMS
	DbWYi4oTAXeyp8dUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following two patches seem to fully fix interrupt parsing issues,
at least on Exynos 4210 Trats board. They must be applied without
Grant's fixup patch, as it doesn't seem to fully solve the problem.

Tomasz Figa (2):
  of: irq: Fix interrupt-map entry matching
  of: irq: Check for reg property presence only when parsing
    interrupt-map

 drivers/of/irq.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
1.8.4.2


