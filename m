Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3IMRPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:15:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59469 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059Ab3IMRPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:15:44 -0400
Date: Fri, 13 Sep 2013 18:15:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] perf tools: Check libunwind for availability of dwarf
 parsing feature
Message-ID: <20130913171503.GC14224@mudshark.cambridge.arm.com>
References: <1379092121-5981-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379092121-5981-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Fri, Sep 13, 2013 at 06:08:41PM +0100, Jean Pihet wrote:
> The newly added dwarf unwinding feature [1] requires:
> . a recent version (>= 1.1) of libunwind,
> . libunwind to be configured with --enable-debug-frame.
> 
> [1] http://www.spinics.net/lists/kernel/msg1598951.html
> 
> Add the corresponding API test in the feature check list.

Any reason not to merge this in with the third patch in original series? I
don't think it's been picked up by anybody yet, so it would make sense to
repost with this fixup after the merge window.

Will
