Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaBFDil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 22:38:41 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43515 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaBFDij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 22:38:39 -0500
Message-ID: <52F303BD.3040704@opersys.com>
Date: Wed, 05 Feb 2014 22:38:37 -0500
From: Karim Yaghmour <karim.yaghmour@opersys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        tom.zanussi@linux.intel.com,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Logging/buffering mechanism comparison? (ring buffer, relay, etc.)
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just wondering if anyone had some pointers on a comparison between the
various logging/buffering mechanisms out there (ring buffer, relay,
lttng buffering, etc.)? Googling was inconclusive.

Anything that has benchmarks/pros/cons would be great.

Thanks,

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
