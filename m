Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3ICRB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:01:28 -0400
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:42130 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841Ab3ICRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:01:27 -0400
Date: Tue, 3 Sep 2013 13:02:49 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.12
In-Reply-To: <20130903132933.GA24955@gmail.com>
Message-ID: <alpine.DEB.2.02.1309031259210.9438@pianoman.cluster.toy>
References: <20130903132933.GA24955@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020203.522615E6.01F8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Ingo Molnar wrote:
>    * New ABI details:
>         . Make Power7 events available via sysfs, by Runzhen Wang.

So we're really going to add 100+ Power7 events to the stable sysfs ABI?
Are all the new events listed under the sysfs ABI documentation?

Are we going to add all of the x86 events too, adding 100kB of unswappable
event listings to every user's kernel whether they use perf_event or not?

Yes, I know I am a broken record on this issue, but I don't feel like 
anyone has clarified the future plans here.

Vince
