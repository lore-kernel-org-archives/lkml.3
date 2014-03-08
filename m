Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbaCHJNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:13:43 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:39573 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaCHJNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:13:35 -0500
Date: Sat, 8 Mar 2014 10:13:31 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf samples too long without perf running (?!?)
Message-ID: <20140308091331.GA282@x4>
References: <CALCETrWSyhJHwfKSBT3giSb0AtvHFBR9PYmhFhFJa=Yabw25iw@mail.gmail.com>
 <1394265078.7215.11.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394265078.7215.11.camel@marge.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.03.08 at 08:51 +0100, Mike Galbraith wrote:
> On Fri, 2014-03-07 at 17:57 -0800, Andy Lutomirski wrote: 
> > On recent (3.13) kernels, I'm frequently getting messages like:
> > 
> > perf samples too long (2503 > 2500), lowering
> > kernel.perf_event_max_sample_rate to 50000
> > 
> > a few seconds to minutes after bootup.  As far as I know, I'm not
> > using perf.  What's going on here?
> 
> 14c63f17b1
> 
> I get those all the time too, just building kernels.

I have:
 echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
in my local startup script since that commit.

-- 
Markus
