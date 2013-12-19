Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3LSPqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:46:47 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55053 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3LSPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:46:46 -0500
Date: Thu, 19 Dec 2013 16:46:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Chen <tuxoko@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
Message-ID: <20131219154642.GA24658@gmail.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
 <20131219115833.GA11279@gmail.com>
 <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Chen <tuxoko@gmail.com> wrote:

> Why not? They're generated files aren't they?

Yes, indeed, you are right, they should be included in the .gitignore.

> By the way, I just found out that test-* will be built depend on the
> detected features.
> Should I include them all?

Yes, that would have been my next observation :-)

I'd suggest that instead of enumerating them all in the .gitignore 
file we should change the naming of the feature check binaries to 
something like test-<xyz>.bin or so, so that a simple test-*.bin 
pattern will ignore all these generated binaries.

Thanks,

	Ingo
