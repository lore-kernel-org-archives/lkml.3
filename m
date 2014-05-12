Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaELHyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:54:18 -0400
Received: from [119.145.14.64] ([119.145.14.64]:22605 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaELHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:54:16 -0400
Message-ID: <53707DD6.2000108@huawei.com>
Date: Mon, 12 May 2014 15:52:54 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        <a.p.zijlstra@chello.nl>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Jiri Olsa" <jolsa@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung@kernel.org>, Huxinwei <huxinwei@huawei.com>,
        <peifeiyue@huawei.com>
Subject: Does perf support different length of user-space hw_breakpoint?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Does perf support different length of user-space hw_breakpoint,
such as  HW_BREAKPOINT_LEN_1/HW_BREAKPOINT_LEN_2/HW_BREAKPOINT_LEN_4/
HW_BREAKPOINT_LEN_8?

Seems perf only support HW_BREAKPOINT_LEN_4/sizeof(long)
by default from the source code and simple test.

May I have your opinions if I want to trace different bytes of
hw_breakpoint addr?

Thanks,

Xia Kaixu

