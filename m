Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaDFNmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaDFNmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:42:20 -0400
Date: Sun, 6 Apr 2014 15:41:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140406134148.GA9942@krava.brq.redhat.com>
References: <20140308065153.GA30311@localhost>
 <20140310125319.GE26334@krava.redhat.com>
 <20140310224023.GA1205@krava.redhat.com>
 <20140311005611.GA1286@krava.redhat.com>
 <20140311121456.GA32527@localhost>
 <20140330124118.GA13006@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330124118.GA13006@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 08:41:18PM +0800, Fengguang Wu wrote:
> This fix is not yet in linux-next, can anyone help merge it? Thanks!

sorry for late reply, I was out last week,
I'll resend this with proper changelog

jirka
