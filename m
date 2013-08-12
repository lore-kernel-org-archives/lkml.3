Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3HLTYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:24:33 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:44187 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739Ab3HLTY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:24:29 -0400
Date: Mon, 12 Aug 2013 15:25:33 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
In-Reply-To: <20130812181956.GB19405@gmail.com>
Message-ID: <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org> <20130805081641.GA24808@gmail.com> <20130805082320.GA9562@infradead.org> <20130805083132.GE26746@gmail.com> <20130805083434.GA20606@infradead.org> <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org> <20130812181956.GB19405@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.5209366C.0132,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Ingo Molnar wrote:

> perf is the exact opposite: no split-up the development culture because 
> they are closely related, yet a relatively disciplined ABI between the 
> components. In fact the ABI is higher quality exactly because development 
> is more integrated and allows for ABI problems to be resolved before they 
> leak out. It also allows for faster iteration of development, without 
> nonsensical ABI steps pulluting the way.

I don't know if I'd use "quality" and "perf ABI" in the same sentence.
It's a horrible ABI; it has the honor of having the longest syscall
manpage, beating out even ptrace.

It also really isn't that stable; I've had perf ABI changes break programs 
I maintain at least three times in the last 2 kernel releases.  Part of 
this is due to the tight coupling into the kernel, in fact the only ABI 
anyone seems to care about is that presented by the perf-tool CLI 
interface; the _actual_ kernel ABI seems like an afterthought.

Vince
