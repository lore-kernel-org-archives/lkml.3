Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3HEG5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:57:47 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41577 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3HEG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:57:46 -0400
Message-ID: <51FF4CE2.30703@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 14:57:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 9/9] perf kvm stat report: Add option to analyze specific
 VM
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-10-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-10-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080506-8256-0000-0000-000008A7953C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 04:05 AM, David Ahern wrote:
> Add an option to analyze a specific VM within a data file. This
> allows the collection of kvm events for all VMs and then analyze
> data for each VM (or set of VMs) individually.

Interesting.

But how can we know which pid is the guest's pid after collecting
the info. Even if the .data file is moved to another box to do
off-analyze?

