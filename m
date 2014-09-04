Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaIDMZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:25:23 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:42213 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654AbaIDMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:25:20 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 08:25:20 EDT
From: Roman Gushchin <klamm@yandex-team.ru>
To: peterz@infradead.org, mingo@redhat.com, Kirill Tkhai <tkhai@yandex.ru>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: [RFC] smt-aware rt load balancer
MIME-Version: 1.0
Message-Id: <77161409833206@webcorp01h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 04 Sep 2014 16:20:06 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

We had an earlier discussion about using real-time policies on modern CPUs
for cpu-bound tasks with "near real-time" execution time expectations (like front-end servers):
https://lkml.org/lkml/2014/4/24/602 .

I sad, that I had a prototype of real-time load balancer (called smart), that performs well in this case.

Now it's ready to be published.

The patch set on top of the 3.10.x branch can be found here:
https://github.com/yandex/smart .

It's stable.
We use them in production for a couple of months on more than thousand machines.
We get noticeable performance increase for many projects with different load patterns
(up to 10-15% in both RPS and latency).

Any feedback, comments, questions are welcome!

Regards,
Roman
