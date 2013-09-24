Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3IXRM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:12:27 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:42038 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3IXRM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:12:26 -0400
Date: Tue, 24 Sep 2013 14:12:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20130924171220.GB2634@ghostprotocols.net>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
 <1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
 <20130917102904.GA27258@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917102904.GA27258@mudshark.cambridge.arm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 17, 2013 at 11:29:04AM +0100, Will Deacon escreveu:
> Arnaldo, Ingo,
> 
> On Mon, Sep 16, 2013 at 10:17:32AM +0100, Jean Pihet wrote:
> > The newly added dwarf unwinding feature [1] requires:
> > . a recent version (>= 1.1) of libunwind,
> > . libunwind to be configured with --enable-debug-frame.
> > 
> > [1] http://www.spinics.net/lists/kernel/msg1598951.html
> > 
> > Add the corresponding API test in the feature check list.
> > 
> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> > ---
> >  tools/perf/config/Makefile          |  2 +-
> >  tools/perf/config/feature-tests.mak | 11 ++++++++++-
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> Can I have an ack for this and the following patch please?
> 
> (http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198531.html)
> 
> Then I can stick these into -next for some more exposure before I queue them
> for 3.13.

I can pick it now that Jiri kinda acked it, right Jiri?

- Arnaldo
