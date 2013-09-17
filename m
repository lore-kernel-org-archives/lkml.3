Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3IQKaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:30:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36297 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab3IQKaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:30:04 -0400
Date: Tue, 17 Sep 2013 11:29:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>, acme@ghostprotocols.net
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20130917102904.GA27258@mudshark.cambridge.arm.com>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
 <1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo, Ingo,

On Mon, Sep 16, 2013 at 10:17:32AM +0100, Jean Pihet wrote:
> The newly added dwarf unwinding feature [1] requires:
> . a recent version (>= 1.1) of libunwind,
> . libunwind to be configured with --enable-debug-frame.
> 
> [1] http://www.spinics.net/lists/kernel/msg1598951.html
> 
> Add the corresponding API test in the feature check list.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> ---
>  tools/perf/config/Makefile          |  2 +-
>  tools/perf/config/feature-tests.mak | 11 ++++++++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)

Can I have an ack for this and the following patch please?

(http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198531.html)

Then I can stick these into -next for some more exposure before I queue them
for 3.13.

Cheers,

Will
