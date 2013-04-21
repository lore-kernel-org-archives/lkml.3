Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3DURNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab3DURNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:13:06 -0400
Date: Sun, 21 Apr 2013 19:10:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 3/5] perf tools: Add breakpoint address mask to the mem
	event parser
Message-ID: <20130421171003.GA6163@redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com> <1365528113-5458-4-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365528113-5458-4-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I am not going to argue, just the question...

On 04/09, Jacob Shin wrote:
>
>   $ perf stat -e mem:0x1000:w:0xf a.out

perhaps, say, perf -e mem:0x1000/0xf:w will look better?

No, I do not understand .y so I do not know if it is simple to
implement or not ;)

Hmm. I did "grep bp_len tools/perf" and it seems that there is
no way to specify bp_len ? Looks like it is always LEN_4...

Once again, I am just asking.

Oleg.

