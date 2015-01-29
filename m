Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbbA2G5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:57:25 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60403 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbA2G5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:57:21 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 29 Jan 2015 15:54:50 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Russell King <linux@arm.linux.org.uk>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH V3 2/2] perf symbols: debuglink should take symfs option
 into account
Message-ID: <20150129065450.GD24182@sejong>
References: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
 <1422340442-4673-3-git-send-email-victor.kamensky@linaro.org>
 <20150129013809.GB24182@sejong>
 <CAA3XUr1twCC6s=1Y3Fk7W3ER9t6hFKJBC57vyzx9zjTD9fMW1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAA3XUr1twCC6s=1Y3Fk7W3ER9t6hFKJBC57vyzx9zjTD9fMW1Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 08:08:30PM -0800, Victor Kamensky wrote:
> Hi  Namhyung,
> 
> On 28 January 2015 at 17:38, Namhyung Kim <namhyung@kernel.org> wrote:
> > Hi Victor,
> >
> > On Mon, Jan 26, 2015 at 10:34:02PM -0800, Victor Kamensky wrote:
> >> Currently code that tries to read corresponding debug symbol
> >> file from .gnu_debuglink section (DSO_BINARY_TYPE__DEBUGLINK)
> >> does not take in account symfs option, so filename__read_debuglink
> >> function cannot open ELF file, if symfs option is used.
> >>
> >> Fix is to add proper handling of symfs as it is done in other
> >> places: use __symbol__join_symfs function to get real file name
> >> of target ELF file.
> >>
> >> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> >> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Cc: Paul Mackerras <paulus@samba.org>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> >> Cc: Jiri Olsa <jolsa@kernel.org>
> >> Cc: Adrian Hunter <adrian.hunter@intel.com>
> >> Cc: Waiman Long <Waiman.Long@hp.com>
> >> Cc: David Ahern <dsahern@gmail.com>
> >> Acked-and-tested-by: David Ahern <dsahern@gmail.com>
> >
> > Acked-by: Namhyung Kim <namhyung@kernel.org>
> 
> Thank you for the Acks! Is there any action items on my side?
> Should I repost patches with your Acks? Or you or Arnaldo
> will add them once they got merged in proper tree for
> upstreaming?

I think Arnaldo will merge them with Acks. ;-)

Thanks,
Namhyung
