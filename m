Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3GCLaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:30:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12567 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3GCLao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:30:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-72-51d40b47fa74
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: yadi.brar01@gmail.com, sbkim73@samsung.com, broonie@kernel.org,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 0/4] Add DT support for s2mps11
Date: Mon, 24 Jun 2013 16:50:54 +0530
Message-id: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkRted+0qgwaWD2hZTHz5hszjwZwej
	xbcrHUwWl3fNYbM4vOIAk8XpblaLiyu+MFnM/d3IajFn+jsmB06PBZ+vsHvsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZJz/vYCuYz14x9ccexgbGE6xd
	jJwcEgImEs8vHWaCsMUkLtxbz9bFyMUhJLCUUeLVlpNACQ6wop5lXhDx6YwSX7+/ZYRw2pgk
	9q1+AlbEJmAk8eqYHcggEQEFic29z1hBapgFLjFKTNt7BGybsIC+xOeLPcwgNouAqsTpR5tZ
	QGxeAReJKy2NLBBXKEi0LjvEDtIsIbCMXWL3p8PsEA0CEt8mH2KBuEhWYtMBZoh6SYmDK26w
	TGAUXMDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMLRP/3vWt4Px5gHrQ4zJQOMmMkuJ
	JucDYyOvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYyBujNeuS0Pbft28dLcvdO6Drwskqkun5WjEXu220c4KFjsSPSrps9STz6m/PM8va046aKK
	xAmD7t8rdK9sZ1VP+5bb68ChrCnIfvtxfbSDn5OrNMPGzOQ1i/Ot+I7sWuDbsZ3luLoOJ6/2
	mmUBt21tdUrzHBb2STya8brcfv1cBbe1drHcRkosxRmJhlrMRcWJAC/m8eaDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQV137iuBBkvWKVlMffiEzeLAnx2M
	Ft+udDBZXN41h83i8IoDTBanu1ktLq74wmQx93cjq8Wc6e+YHDg9Fny+wu6xc9Zddo9NqzrZ
	PO5c28PmMe9koEffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzDj5eQdbwXz2iqk/9jA2MJ5g7WLk4JAQMJHoWebVxcgJZIpJXLi3nq2LkYtDSGA6o8TX
	728ZIZw2Jol9q58wgTSwCRhJvDpmB9IgIqAgsbn3GStIDbPAJUaJaXuPsIIkhAX0JT5f7GEG
	sVkEVCVOP9rMAmLzCrhIXGlpZIHYpiDRuuwQ+wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxgiPnmfQOxlUNFocYBTgYlXh4HZ5dChRiTSwrrsw9xCjBwawkwjvxz+VAId6UxMqq
	1KL8+KLSnNTiQ4zJQNsnMkuJJucDozqvJN7Q2MTc1NjU0sTCxMySNGElcd6DrdaBQgLpiSWp
	2ampBalFMFuYODilGhhlvNZefbG/JUlY+tBH1f6F67mdr/41SeS5rRLqqKX8Y3kD65YCjuWv
	J+70tRXovG5iPZNVtZHp0PrDNr94mpe9MXylmnPSoFFt5SaupM0TZ8fNb5X4erq6fmqXyJ2U
	5LtrGI9rvmW9UtrVyfBnafdthQl8m593r7JewNVV65W4wvZna+pT5lYlluKMREMt5qLiRACC
	umCk4AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly this series adds dt support for s2mps11 in mfd and regulator driver.
It also implements the set_voltage_time_sel() for bucks as we can not use
generic implementation as we need to take care of ramp_disable and ramp_delay
sharing by some bucks.

Yadwinder Singh Brar (4):
  regulator: s2mps11: Convert ramp rate to uV/us and set default ramp
    rate
  regulator: s2mps11: Implement set_voltage_time_sel() ops for bucks
  mfd: s2mps11: Add device tree support
  regulator: s2mps11: Add device tree support

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   98 ++++++++++++
 drivers/mfd/sec-core.c                            |    3 +
 drivers/regulator/s2mps11.c                       |  176 +++++++++++++++++++--
 include/linux/mfd/samsung/s2mps11.h               |    1 +
 4 files changed, 264 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

