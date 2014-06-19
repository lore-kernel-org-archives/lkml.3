Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbaFSIuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:50:15 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59259 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757598AbaFSIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:50:13 -0400
Message-ID: <1403167807.23136.31.camel@x220>
Subject: clk: hisilicon: ARCH_HIP04 and ARCH_HIX5HD2?
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Turquette <mturquette@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Haifeng Yan <haifeng.yan@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 10:50:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2014 08:50:11.0343 (UTC) FILETIME=[7ACC39F0:01CF8B9B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Commit d3e6573c48f4 ("clk: hip04: add clock driver") was included in
v3.15. That clock driver is built only if CONFIG_ARCH_HIP04 is set.

And commit 5efaf09021a5 ("clk: hisi: add clk-hix5hd2.c") was included in
v3.16-rc1. And that driver is built only if CONFIG_ARCH_HIX5HD2 is set.

1) Neither the symbol ARCH_HIP04 nor the symbol ARCH_HIX5HD2 is part of
v3.16-rc1. These symbols are also not part of next-20140619. I assume
that both are pending somewhere. Is that correct?

2) It would probably be nice if these drivers got some (automatic) build
coverage until those symbols enter the tree. I don't know how that could
be achieved.


Paul Bolle

