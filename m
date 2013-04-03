Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815Ab3DCMt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:49:57 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63939 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758951Ab3DCMt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <y0mvc83u79f.fsf@fche.csb>
References: <20130403075017.GA2534@suse.de>
	<CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com>
	<y0mvc83u79f.fsf@fche.csb>
Date: Wed, 3 Apr 2013 14:49:53 +0200
Message-ID: <CAFTL4hxx_GHoa4uguSAtY0A=cC43qJPKvpqaoguS-WAjFj+HSw@mail.gmail.com>
Subject: Re: systemtap broken by removal of register_timer_hook
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3 Frank Ch. Eigler <fche@redhat.com>:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>
>> [...]
>> Sometimes I don't mind keeping around code in the kernel for out of
>> tree users, depending on the case. But in this specific matter we have
>> more standard ways to do this kind of hook: kprobes, static
>> tracepoints. A tracepoint on the timer tick would be useful BTW, and
>> you could reuse it.
>
> Thanks for noticing!  IMO kprobes would be too heavyweight for this.
> A new static tracepoint would be fine, especially if it passes the
> same pt_regs* pointer as the former hook did.

Sounds good, would you like to propose a version? We are also
interested in a timer tick event tracepoint for dynticks debugging.

Thanks!
