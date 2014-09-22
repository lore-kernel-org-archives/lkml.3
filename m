Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaIVDg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:36:28 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:50362 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIVDg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:36:27 -0400
Message-ID: <541F990F.7030806@huawei.com>
Date: Mon, 22 Sep 2014 11:35:43 +0800
From: duzhiping <duzhiping.du@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <rostedt@goodmis.org>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
CC: <wangnan0@huawei.com>
Subject: itrace: An interrupts tracing tool
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.75.23]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.541F993A.0013,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 4a13b2de64f0ed1e5481faa01796f472
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Many functions depends on interrupts in Linux system, when the interrupts occur an error, it may cause fatal problem.

  Then, we should record their trace when interrupts in and out. The recorded information could help us analyze interrupts errors.

  Itrace is such an interrupts trace tool we have developed, it provides config interface and trace information through "procfs".

  Do you think it has the value to upstream?

  Thanks
  Zhiping Du

