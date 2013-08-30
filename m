Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3H3L4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3H3L4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:56:36 -0400
Date: Fri, 30 Aug 2013 13:56:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: perf: callchain feature on ARM - question about libunwind
 API
Message-ID: <20130830115632.GB9218@krava.brq.redhat.com>
References: <CAFrcx1n5eA4zz+nUhraE_fi_Usc=PCZTC=RCT=S285K4=jqHSg@mail.gmail.com>
 <CAFrcx1nr4-qyzC=zFRdnMavHy5p_r9Ng+zSVwNPk6snYtBm6gw@mail.gmail.com>
 <521CCFD8.90201@gmail.com>
 <20130829135216.GA1032@krava.brq.redhat.com>
 <CAFrcx1=U8SapYd=Hw8YaAnKNggJMuY4r03zYeevc0Ttq5hFr7Q@mail.gmail.com>
 <20130830114903.GC1023@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830114903.GC1023@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 01:49:03PM +0200, Jiri Olsa wrote:
> On Thu, Aug 29, 2013 at 07:15:00PM +0200, Jean Pihet wrote:
> 
> SNIP
> 
> > 
> > The problem is that it is slow as hell (couple of minutes to report
> > the callchain from a simple test app ;-|). I will look at the sampling
> > rate and the caching next.
> 
> FYI there's elfutils alternative grewing now via libdw providing
> API to do the 'remote unwind' as in libunwind. I'm not completely
> sure, but I think it should support both .eh_frames and .debug_frames.

ok, I checked and it does ;)
