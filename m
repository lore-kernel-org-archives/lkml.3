Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaLEQqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:46:42 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29124 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLEQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:46:39 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-dd-5481e16c0dd4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 0/3] devfreq: exynos: Add driver for Exynos3250
Date: Fri, 05 Dec 2014 17:46:25 +0100
Message-id: <1417797988-29225-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Nd2ch40hBlc38llsnLGe1eL6l+es
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dkcfsyr8XaI3fZLW43
	rmCzWLXrD6MDn0dLcw+bx85Zd9k9Nq3qZPPYvKTeo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0S
	uDJmPTvAXnCdo+LLso9sDYyb2boYOTgkBEwkLkz372LkBDLFJC7cWw8U5uIQEljKKPF/wxEm
	CKePSeLdtsksIFVsAsYSm5cvAasSEXjJJNGyrZ8RxGEW2M8o0bLpG1iVsICtxKVzn8FsFgFV
	iclbnjGC2LwC7hKrD81mhdgnJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefn
	bmKEhNyXHYyLj1kdYhTgYFTi4b1g3RgixJpYVlyZe4hRgoNZSYQ3eTZQiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA6NMs7imQuMWQaGq/o5l6zbwyE7sF0j3XH+ecWuntHwbm4TTljMTI2X14hYf
	2XhYUHn9BY7je1K2vbFY1LAsZk5g8tv4NX8EtIpdBY9VvVCXecD2edoxy1Nu07Z+86pRMdZd
	22NxYMEih7xyI4GvIcpxrCfSwpI7pnExnSzZ3cEtXDNnmtGqT0osxRmJhlrMRcWJAGm/HvMX	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The aim of patchset is to gather feedback about adding new devfreq driver for
Exynos 3250, along with the bindings.

Chanwoo,
You were the author of our initial exynos3_bus.c driver so do you
want me to add your Signed-off-by?

Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  devfreq: dt-bindings: Document Exynos3250 devfreq driver
  devfreq: exynos: Add driver for Exynos3250
  ARM: dts: Add devfreq to Exynos3250 and Rinato board

 .../bindings/arm/samsung/exynos3250-devfreq.txt    |  66 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  10 +
 arch/arm/boot/dts/exynos3250.dtsi                  |  32 +
 drivers/devfreq/Kconfig                            |  12 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/exynos/Makefile                    |   1 +
 drivers/devfreq/exynos/exynos3_bus.c               | 842 +++++++++++++++++++++
 7 files changed, 964 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
 create mode 100644 drivers/devfreq/exynos/exynos3_bus.c

-- 
1.9.1

