Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3IXIzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:55:36 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:36130 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3IXIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130917102904.GA27258@mudshark.cambridge.arm.com>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
	<1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
	<20130917102904.GA27258@mudshark.cambridge.arm.com>
Date: Tue, 24 Sep 2013 10:55:32 +0200
Message-ID: <CAFrcx1nnx0+kWx3z3A86Fwz13RYRVSPSG0YHBcxFeFQP8W7jBg@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf
 parsing feature
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hin

On 17 September 2013 12:29, Will Deacon <will.deacon@arm.com> wrote:
> Arnaldo, Ingo,
>
> On Mon, Sep 16, 2013 at 10:17:32AM +0100, Jean Pihet wrote:
>> The newly added dwarf unwinding feature [1] requires:
>> . a recent version (>= 1.1) of libunwind,
>> . libunwind to be configured with --enable-debug-frame.
>>
>> [1] http://www.spinics.net/lists/kernel/msg1598951.html
>>
>> Add the corresponding API test in the feature check list.
>>
>> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> ---
>>  tools/perf/config/Makefile          |  2 +-
>>  tools/perf/config/feature-tests.mak | 11 ++++++++++-
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> Can I have an ack for this and the following patch please?
>
> (http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198531.html)
>
> Then I can stick these into -next for some more exposure before I queue them
> for 3.13.
>
> Cheers,
>
> Will

Ping on the series. The two patches above (3/4 and 4/4) are generic
while the two others are impacting ARM only.
Is it possible to get an Ack for the generic ones?

Kind regards,
Jean
