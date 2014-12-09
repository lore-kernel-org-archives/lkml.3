Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaLICOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:14:31 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:23726 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLICOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:14:30 -0500
Message-ID: <54865AF2.5040707@huawei.com>
Date: Tue, 9 Dec 2014 10:14:10 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
CC: Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND][PATCH v15 7/7] ARM: kprobes: enable OPTPROBES for ARM
 32
In-Reply-To: 1418047765-53197-8-git-send-email-wangnan0@huawei.com
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Looks like v15 patch solves the problems found in patch v13 and v14. I run Tixy's test
cases in a loop for a whole night on two real unpublished Hisilicon ARM A15 SoCs (I
backported kprobes to 3.10 kernel), no problem arise, they are still running now.

