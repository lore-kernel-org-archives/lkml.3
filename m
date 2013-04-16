Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3DPItP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:49:15 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47319 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3DPItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:49:12 -0400
Date: Tue, 16 Apr 2013 10:49:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [build error] perf/urgent broken due to
 INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG
Message-ID: <20130416084909.GA8404@gmail.com>
References: <alpine.DEB.2.02.1304152002150.3952@chino.kir.corp.google.com>
 <20130416075212.GA6565@gmail.com>
 <CABPqkBSzyswo+bWoESsXufi-OBw820m6iQ3ztE12H5XXRtFiDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSzyswo+bWoESsXufi-OBw820m6iQ3ztE12H5XXRtFiDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Tue, Apr 16, 2013 at 9:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * David Rientjes <rientjes@google.com> wrote:
> >
> >> Commit 3de4ad210387 ("perf/x86: Fix offcore_rsp valid mask for SNB/IVB") in
> >> perf/urgent breaks the build:
> >
> > Hm, that's was me resolving the conflicts incorrectly.
> >
> > Stephane, mind sending a tested version of the patch against current -git that can
> > be applied to v3.9 and can be backported?
> >
>
> To make backport clean, I need to generate a patch against a kernel git tree 
> which does not have the PEBS-LL (LDLAT) support. tip.git already has PEBS-LL, so 
> I need to use another tree.

You can just use the tip:perf/urgent branch for that, it does not have the LDLAT 
patches. But using Linus's tree is fine as a base too.

Thanks,

	Ingo
