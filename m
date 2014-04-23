Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaDWLwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:52:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63038 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaDWLwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:52:06 -0400
Message-ID: <5357A93C.3050604@hisilicon.com>
Date: Wed, 23 Apr 2014 19:51:24 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@linaro.org>, <xuwei5@hisilicon.com>
Subject: [PATCH 0/2] ARM: hip04: add GPIO support
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.65.131]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the support for the GPIOs of Hisilicon Soc hip04. We use
the dwapb GPIO driver here.

The second patch is based on hip04.dtsi[1] which is upstreaming now.
[1] http://article.gmane.org/gmane.linux.ports.arm.kernel/317491

Zhou Wang (2):
  ARM: hip04: set ARCH_NR_GPIO to 128
  ARM: dts: hip04: add gpio pieces

 arch/arm/Kconfig             |    1 +
 arch/arm/boot/dts/hip04.dtsi |   76 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

-- 1.7.9.5

