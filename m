Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3JDRws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:52:48 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56518 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JDRwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:52:47 -0400
Date: Fri, 4 Oct 2013 10:52:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Olof Johansson <olof@lixom.net>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 3
Message-ID: <20131004175240.GA9301@roeck-us.net>
References: <20131004010230.GI27287@sirena.org.uk>
 <524E50DB.3060707@roeck-us.net>
 <CAOesGMhc5WYRFcBVSHShg6h8hn4HueGZtGCFKkzfX4SQEe_5LQ@mail.gmail.com>
 <524EC658.90706@roeck-us.net>
 <20131004143440.GO27287@sirena.org.uk>
 <CAOesGMhrF+RB9O2f1JGtkT02amZQCx1nUo0GjmeBErYiSHSVZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhrF+RB9O2f1JGtkT02amZQCx1nUo0GjmeBErYiSHSVZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:00:20AM -0700, Olof Johansson wrote:
> On Fri, Oct 4, 2013 at 7:34 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Oct 04, 2013 at 06:44:56AM -0700, Guenter Roeck wrote:
> >
> >> Great summaries. Do you have a single builder, or several builders and
> >> collect the results ? Either case, any chance sharing the buildbot scripts ?
> >
> > There's a repo at:
> >
> >   git://git.linaro.org/people/khilman/build-scripts.git
> 
> A git url is frustrating, especially when the gitweb isn't configured
> to use the same paths.
> 
> https://git.linaro.org/gitweb?p=people/khilman/build-scripts.git;a=summary
> 
I was able to clone it, though.

> > (Olof and Kevin have been collaborating on them).
> 
> What I use is quite different from that, but the origins are more or
> less the same.
> 
No problem. I'll see if there is anything I can use to improve my buildbot
scripts. My key problem is that I have not figured out how to merge
results from multiple builders into a single summary e-mail. Hope I can
solve that problem at some point. Time is always the problem.

Thanks,
Guenter
