Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaAHLx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:53:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:58249 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbaAHLxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:53:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,624,1384329600"; 
   d="scan'208";a="455386713"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
In-Reply-To: <20140107154805.GD20765@two.firstfloor.org>
References: <20131219103134.GD30183@twins.programming.kicks-ass.net> <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com> <20131219112812.GY21999@twins.programming.kicks-ass.net> <20131219123955.GA18186@gmail.com> <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com> <20131219151024.GI16438@laptop.programming.kicks-ass.net> <87iotw6bwx.fsf@tassilo.jf.intel.com> <20140106220509.GI30183@twins.programming.kicks-ass.net> <20140107005231.GZ20765@two.firstfloor.org> <20140107084215.GO30183@twins.programming.kicks-ass.net> <20140107154805.GD20765@two.firstfloor.org>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 08 Jan 2014 13:53:15 +0200
Message-ID: <87a9f6ellg.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> So create two events, one for the PT stuff and one to track the
>> side-band stuff. We have a NOP event for just this purpose.
>
> Ok I guess that could work.
>
> Essentially replace the magic mmap offset with a second fd.
>
> Alex, what do you think?

Yes, that's what I suggested some time ago in [1]. A second buffer
(through another fd or otherwise) is an essential thing from my point of
view.

[1] http://marc.info/?l=linux-kernel&m=138737306725663

Regards,
--
Alex
