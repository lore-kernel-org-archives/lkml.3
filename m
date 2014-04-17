Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161390AbaDQNWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:22:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44970 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbaDQNV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:21:59 -0400
Date: Thu, 17 Apr 2014 15:21:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140417132157.GC4321@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1=0TddfPS322728w3AsK5SzJ1sq-7VTbE=+Pb-EqcrncQ@mail.gmail.com>
 <20140417125030.GA4321@pd.tnic>
 <CAFrcx1noiierVs1tpkoqQ=L-Si0Xt5yVBvG3jgpi4hXepcabrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFrcx1noiierVs1tpkoqQ=L-Si0Xt5yVBvG3jgpi4hXepcabrg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Thu, Apr 17, 2014 at 03:17:01PM +0200, Jean Pihet wrote:
> Yes indeed!
> 
> Ingo,
> Is the perf support for persistent event needed, or can this series be
> reviewed as is?
> 
> In the meantime I am now working on the perf tool:
> - add persistent events,
> - factor out the code and provide a library (libperf) for other tool
> to use it (e.g. monitoring daemon).

Ok, good. I'm doing a bit too:

https://lkml.org/lkml/2014/4/13/20

so let's synchronize and get this thing going. I'll add you to my CC
list on future submissions.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
