Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaLRJ3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:29:42 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:25728 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaLRJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:29:40 -0500
From: He Kuang <hekuang@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>
CC: <ananth@in.ibm.com>, <linux-kernel@vger.kernel.org>,
        <anil.s.keshavamurthy@intel.com>, <wangnan0@huawei.com>,
        <hekuang@huawei.com>
Subject: [RFC]kprobes functionality with kernel-hacking disabled
Date: Fri, 19 Dec 2014 01:41:42 +0800
Message-ID: <1418924502-7229-1-git-send-email-hekuang@huawei.com>
X-Mailer: git-send-email 2.2.0.33.gc18b867
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.189]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54929E7D.02B6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 719bdbd592e1ce34bad618fae771889f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kprobes is so excellent in performance analysis. But in many practical 
performance analysis scenarios, performance & debuging related configs
maybe disabled. So, we should recompile the kernel for further analysis,
this is not so convinient.

I've read this thread asked a question to use kprobes as a module
(https://lkml.org/lkml/2012/5/15/46), and know the ftrace dependence
 issue. But when we meet a kernel compiled without CONFIG_KPROBES*, 
the only thing we need is the basic kprobes funtionality, have ftrace 
or not is not the major problem, in fact, most cases ftrace is disabled
too.

Do you have any advices on the conflicts between kernel hacking tools and 
practical kernel which compiled without it? If there is no kprobes 
module, what should we use?

Signed-off-by: He Kuang <hekuang@huawei.com>

-- 
1.7.9.5

