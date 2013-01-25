Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3AYLYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:24:00 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49271 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3AYLX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:23:57 -0500
X-AuditID: 85900ec0-d867eb900000152f-b6-51026b4ad183
Message-ID: <51026B49.4060803@hitachi.com>
Date: Fri, 25 Jan 2013 20:23:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Josh Stone <jistone@redhat.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [GIT PULL] uprobes: pre-filtering
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com> <20130124154018.GA8580@redhat.com> <20130124154159.GB32071@gmail.com> <20130124170612.GA14823@redhat.com> <20130125064629.GD23723@linux.vnet.ibm.com>
In-Reply-To: <20130125064629.GD23723@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/25 15:46), Srikar Dronamraju wrote:
> The other alternative is to extend the current abi and pass the
> prefilter option. Should we extend the abi for userspace tracing is
> obviously debatable.

Hmm, afaik, ftrace has set_ftrace_pid and perf record
also has --pid option. I think you can hook those
to set pre-filter option at first. Of course, since
those are universal options, we may need other per-event
pid filter.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


