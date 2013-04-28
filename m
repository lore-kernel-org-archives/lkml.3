Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3D1FvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 01:51:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54320 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab3D1FvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 01:51:14 -0400
Message-ID: <517CB8AC.600@zytor.com>
Date: Sat, 27 Apr 2013 22:50:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] perf tools: allow user to specify hardware breakpoint
 bp_len
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com> <1367002666-6910-3-git-send-email-jacob.shin@amd.com> <20130427165856.GA30282@redhat.com>
In-Reply-To: <20130427165856.GA30282@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 09:58 AM, Oleg Nesterov wrote:
> 
> Stupid question... So X86_FEATURE_BPEXT only works for r/w? I mean, it
> doesn't allow to specify the mask for an execute breakpoint?
> 

x86 execute breakpoints in general are only a single byte, which has to
be the first byte of the instruction.

	-hpa


