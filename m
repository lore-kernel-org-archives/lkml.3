Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3EFNKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:10:52 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:33484 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3EFNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:10:50 -0400
Message-ID: <5187AB9C.5020600@huawei.com>
Date: Mon, 6 May 2013 21:09:48 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <wsa@the-dreams.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 0/2]  i2c: fix two wrong mem release
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 fix two wrong mem release

Libo Chen (2):
  i2c: i2c-bfin-twi:don`t free peripheral before it`s init successful
  i2c: pxa: no need release_mem_region before request_mem_region
    successful

 drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
 drivers/i2c/busses/i2c-pxa.c      |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

