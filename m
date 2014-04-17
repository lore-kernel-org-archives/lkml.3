Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945936AbaDQNRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:17:04 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47238 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaDQNRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140417125030.GA4321@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
	<CAFrcx1=0TddfPS322728w3AsK5SzJ1sq-7VTbE=+Pb-EqcrncQ@mail.gmail.com>
	<20140417125030.GA4321@pd.tnic>
Date: Thu, 17 Apr 2014 15:17:01 +0200
Message-ID: <CAFrcx1noiierVs1tpkoqQ=L-Si0Xt5yVBvG3jgpi4hXepcabrg@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On 17 April 2014 14:50, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Apr 17, 2014 at 02:44:26PM +0200, Jean Pihet wrote:
>> Hi,
>>
>> Ping on this series. Are there some opinions or interest in this?
>
> Just checking whether you've read my mail from 2-ish weeks ago:
>
> https://lkml.kernel.org/r/20140329094250.GA11987@nazgul.tnic
Yes indeed!

Ingo,
Is the perf support for persistent event needed, or can this series be
reviewed as is?

In the meantime I am now working on the perf tool:
- add persistent events,
- factor out the code and provide a library (libperf) for other tool
to use it (e.g. monitoring daemon).

I surely will let you know!

Thx,
Jean

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
