Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3D2MeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab3D2MeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:34:14 -0400
Date: Mon, 29 Apr 2013 14:30:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V4 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint
	Extensions
Message-ID: <20130429123051.GA15502@redhat.com>
References: <1367129152-11621-1-git-send-email-jacob.shin@amd.com> <20130428163127.GA25477@redhat.com> <20130429111248.GA12816@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429111248.GA12816@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Obviously I can't ack the changes in this area, but to me the whole
> > series looks fine.
>
> Thanks Oleg - can I add your Reviewed-by tags?

Yes, sure, thanks,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

