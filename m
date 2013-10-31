Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3JaQeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:34:13 -0400
Received: from fifo99.com ([67.223.236.141]:55720 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3JaQeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:34:11 -0400
Date: Thu, 31 Oct 2013 09:33:40 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131031163339.GA31282@fifo99.com>
References: <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
 <87ob66nyqc.fsf@linaro.org>
 <20131030232412.GA10229@fifo99.com>
 <CAOesGMi2E1Ynr4rWY1eBmcZeB7Vahb5VdPUVs1ebLJowH1kpWw@mail.gmail.com>
 <20131031024538.GA17886@fifo99.com>
 <CAOesGMiEGJ8iMe=_-eJzhx3sRQO8VKbKGD-iLWsRztxUeJWJbQ@mail.gmail.com>
 <20131031120727.GA28330@fifo99.com>
 <CAOesGMge9JADoLtM8s0LWfy3gs4mpaD1Kofdnn=scOhF86+GcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMge9JADoLtM8s0LWfy3gs4mpaD1Kofdnn=scOhF86+GcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 08:53:58AM -0700, Olof Johansson wrote:
> On Thu, Oct 31, 2013 at 5:07 AM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Wed, Oct 30, 2013 at 10:19:30PM -0700, Olof Johansson wrote:
> >> On Wed, Oct 30, 2013 at 7:45 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> >> > On Wed, Oct 30, 2013 at 05:36:58PM -0700, Olof Johansson wrote:
> >> >> On Wed, Oct 30, 2013 at 4:25 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> >> >>
> >> >> > So the current users of those platforms are, what SOL ?
> >> >>
> >> >> What users? Show me one.
> >> >
> >> > What am I chop liver ?
> >>
> >> Ah, right. So, what platforms do you currently rely on mainline
> >> support for? Please be precise so we can figure out what needs to be
> >> kept and not.
> >
> > The only one I don't have is 7x30, as I said in prior emails.
> 
> That's not actually what I asked. Which ones of them do you rely on
> mainline support for?

I rely on mainline support for 8x50 and G1 trout. This is starting to feel
like an interogation .. The only reason I'm tolerating this is because I
know you'll make some attempt to accept these patches over my already
explicit objections.

Daniel
