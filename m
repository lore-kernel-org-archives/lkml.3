Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3F1JEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:04:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47071 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3F1JEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:04:37 -0400
Message-ID: <51CD518B.2050106@huawei.com>
Date: Fri, 28 Jun 2013 17:04:11 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Liang Li <liang.li@windriver.com>, Li Zefan <lizefan@huawei.com>
Subject: request for stable inclusion
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Jiri or Liang Li

384e301e3519599b000c1a2ecd938b533fc15d85
pch_uart: fix a deadlock when pch_uart as console

This looks applicable to stable-3.4, and it
was built successful for me. What do you think?

Thanks!
Yijing.

