Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3E0BUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:20:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53178 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab3E0BUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:20:12 -0400
X-AuditID: cbfee68e-b7f276d000002279-5f-51a2b4ca77e9
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        "'Dirk Brandewie'" <dirk.j.brandewie@intel.com>, cpgs@samsung.com
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] cpufreq / intel_pstate: Add additional supported
 CPU ID
Date: Mon, 27 May 2013 10:20:09 +0900
Message-id: <002601ce5a78$5479b200$fd6d1600$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfd1TWxYFGnxulrd4eUjT4vhzTYsl
	zdwWl3fNYbN4vOItu8WCjY8YHdg8Fu95yeTRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGTPO
	/mEr+MVesfC3WQPjM7YuRk4OCQETiYf3WlggbDGJC/fWA8W5OIQEljFKzLrWwgRTNGvCVBaI
	xCJGib6rbewQzl9Gid+z54FVsQnoShxbv4UVxBYR8JY4NeUXM0gRs8BERoklf3uBEhxAHdwS
	q5uDQGo4BXgk1v3pZAYJCwuESmxvVwcJswioShzsOwZ2Ea+AncS9G5vYIWxBiR+T74HFmQW0
	JNbvPM4EYctLbF7zFmyMhIC6xKO/uhAXtDBK3DmnDFEiIrHvxTtGkGskBM6xS8zpms4IsUtA
	4tvkQywQvbISmw4wQ/wrKXFwxQ2WCcAgQLJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFRnrF
	ibnFpXnpesn5uZsYIXHZt4Px5gHrQ4zJQOsnMkuJJucD4zqvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzK2iuVNvx9ZDXFc47kFscnqxZ9aLJ/
	s0PsR8andZO6rr5+fYu3epkM61WpBpMbL6vSTm55q5S/0Me5/jbDa65UboYQ7Rtr3jm5aJnZ
	+9YYyr47ODdi001bO1E242/ml76dkZl0ePu+PylfLT8crTlvNzXeychT6fXzrtn7giNmxSgd
	jN/178d3JZbijERDLeai4kQAQAADauECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd1TWxYFGvzcJmXx8pCmxfHnmhZL
	mrktLu+aw2bxeMVbdosFGx8xOrB5LN7zksmjb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwnrGDNmnP3DVvCLvWLhb7MGxmdsXYycHBICJhKzJkxlgbDFJC7c
	Ww8U5+IQEljEKNF3tY0dwvnLKPF79jwmkCo2AV2JY+u3sILYIgLeEqem/GIGKWIWmMgoseRv
	L1CCA6iDW2J1cxBIDacAj8S6P53MIGFhgVCJ7e3qIGEWAVWJg33HwBbzCthJ3LuxiR3CFpT4
	MfkeWJxZQEti/c7jTBC2vMTmNW/BxkgIqEs8+qsLcUELo8Sdc8oQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/6Z1A7GlQ0WhxgFOBiV
	eHh/zFoUKMSaWFZcmXuIUYKDWUmENyEaKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wISU
	VxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MKxikrgiujHni
	MGuK+NanSV0vs582iz49JLzb/dpiYy3hjt7D8y7wL1pyfpFinrjH8g26ptHarpseFjHYMtQl
	fahd4Bd5vn3d1sY4va/qG0sz7+etSObKU25bb/rC5JdmJU+j3fWsiT8nyp8/X1D4eknJTL9/
	f5/VMtoE/gv7u6Rk3v3/yTGblViKMxINtZiLihMBevNX/j4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Dirk Brandewie <dirk.j.brandewie@intel.com>"

commit c96d53d600643ee0adfd1cb90814bd9510e62b71 upstream

Add CPU ID for Ivybrigde processor.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/cpufreq/intel_pstate.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index d8a8c9b..bd9fae6 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -570,6 +570,7 @@ static void intel_pstate_timer_func(unsigned long
__data)
 static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x2a, default_policy),
 	ICPU(0x2d, default_policy),
+	ICPU(0x3a, default_policy),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
1.7.9.5

