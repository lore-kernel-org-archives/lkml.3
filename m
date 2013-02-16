Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3BPCNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:13:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39797 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3BPCNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:13:35 -0500
Message-ID: <511EEAE1.1040106@zytor.com>
Date: Fri, 15 Feb 2013 18:11:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>  <511ECE53.8040801@zytor.com> <1360979993.23152.122.camel@gandalf.local.home>
In-Reply-To: <1360979993.23152.122.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This switch should always be outside the funny NMI and debug zone.
> I think you missed a patch that I sent you to deal with exactly this:
>
> https://lkml.org/lkml/2013/2/1/532
>
> I sent it directly to you, maybe it got buried in your INBOX.
>

I saw it.  It had a:

Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>

... so I was holding off on doing anything with it.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

