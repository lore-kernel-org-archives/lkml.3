Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3INGCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 02:02:31 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38020 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3INGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 02:02:29 -0400
Date: Sat, 14 Sep 2013 08:02:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] perf tools: Check libunwind for availability of dwarf
 parsing feature
Message-ID: <20130914060226.GD364@gmail.com>
References: <1379092121-5981-1-git-send-email-jean.pihet@linaro.org>
 <20130913171503.GC14224@mudshark.cambridge.arm.com>
 <CAFrcx1nE8GUa59-5TsJxH9+deBLB-vuX2R+b8dxtgFvOX8FC7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1nE8GUa59-5TsJxH9+deBLB-vuX2R+b8dxtgFvOX8FC7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@linaro.org> wrote:

> Hi Will,
> 
> On 13 September 2013 19:15, Will Deacon <will.deacon@arm.com> wrote:
> > Hi Jean,
> >
> > On Fri, Sep 13, 2013 at 06:08:41PM +0100, Jean Pihet wrote:
> >> The newly added dwarf unwinding feature [1] requires:
> >> . a recent version (>= 1.1) of libunwind,
> >> . libunwind to be configured with --enable-debug-frame.
> >>
> >> [1] http://www.spinics.net/lists/kernel/msg1598951.html
> >>
> >> Add the corresponding API test in the feature check list.
> >
> > Any reason not to merge this in with the third patch in original series? I
> > don't think it's been picked up by anybody yet, so it would make sense to
> > repost with this fixup after the merge window.
>
> Yes you are right Will repost with this patch folded into the third 
> patch, or as a fourth patch. Any preference?

I suspect it should be a separate patch, but _prior_ the patch that makes 
use of this new facility.

That way it's bisection-safe.

Thanks,

	Ingo
