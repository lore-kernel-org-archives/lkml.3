Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3DPISH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:18:07 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:51047 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3DPISE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:18:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130416075212.GA6565@gmail.com>
References: <alpine.DEB.2.02.1304152002150.3952@chino.kir.corp.google.com>
	<20130416075212.GA6565@gmail.com>
Date: Tue, 16 Apr 2013 10:18:02 +0200
Message-ID: <CABPqkBSzyswo+bWoESsXufi-OBw820m6iQ3ztE12H5XXRtFiDw@mail.gmail.com>
Subject: Re: [build error] perf/urgent broken due to INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 9:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * David Rientjes <rientjes@google.com> wrote:
>
>> Commit 3de4ad210387 ("perf/x86: Fix offcore_rsp valid mask for SNB/IVB") in
>> perf/urgent breaks the build:
>
> Hm, that's was me resolving the conflicts incorrectly.
>
> Stephane, mind sending a tested version of the patch against current -git that can
> be applied to v3.9 and can be backported?
>
To make backport clean, I need to generate a patch against a kernel
git tree which
does not have the PEBS-LL (LDLAT) support. tip.git already has
PEBS-LL, so I need
to use another tree.
