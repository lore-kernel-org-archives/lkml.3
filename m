Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3JaTjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:39:33 -0400
Received: from fifo99.com ([67.223.236.141]:55310 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab3JaTjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:39:31 -0400
Date: Thu, 31 Oct 2013 12:39:13 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131031193912.GB31722@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
 <87ob66nyqc.fsf@linaro.org>
 <20131030232412.GA10229@fifo99.com>
 <8738nhnz4s.fsf@linaro.org>
 <20131031173506.GA31722@fifo99.com>
 <87eh71mfyh.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh71mfyh.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 11:51:34AM -0700, Kevin Hilman wrote:
> Daniel Walker <dwalker@fifo99.com> writes:
> 
> > On Thu, Oct 31, 2013 at 10:12:03AM -0700, Kevin Hilman wrote:
> >> Daniel Walker <dwalker@fifo99.com> writes:
> >> 
> >> 
> >> No.  The idea behind splitting them is to allow current platforms with
> >> active maintainers to progress without being held back.  The older
> >> platforms can stay and have an opportunity to modernize. 
> >> 
> >> The kernel is a moving target, without some minimal effort to keep
> >> platforms up to date, the effort to continue to maintain/modernize them
> >> can become more of a pain than it's worth.  If maintainers of these older
> >> platforms are willing to put in the work, nobody will be SOL.  If
> >> nobody shows interest in modernizing these older platforms (which seems
> >> to be the case based on the last couple years), then it is reasonable
> >> IMO for them to fade away slowly.
> >
> >
> > According to a prior email Tony suggested that OMAP was split for purely
> > technical reasons.. If code is shared in some way , or has synergies, and there's no
> > technical reason to split a sub-architecture, then to me there's no win in splitting
> > things.. 
> 
> The wins have already been well described in this thread in terms of
> maintenance of newer platforms using modern kernel infrastructure.


That's not very concrete .. Can you be specific, and what platforms are
we talking about?


> > It's just more directories, more confusion etc.. The confusion
> > would come from someone wanting to find the code related to a platform,
> > but woops there's a bunch of directories, or code flow and how the
> > sub-architecture is strung together .. Personally I found OMAP very
> > confusing in that regard.
> >
> > ARM and the sub-architectures is already confusing I don't think we need
> > to start compounding the problem by allowing random whatever-you-want
> > sub-directories from every sub-architecture.
> 
> Randomness is quite a bit of an exaggeration of what's been proposed
> here.

No one has proposed anything, as far as I can tell.


> These decisions are made on a case-by-case basis and is this case is
> being done for ease of maintainence for newer platforms, which may not
> be a "technical reason" for you, but is important for overall
> maintenance of arm-soc.

Who's making this decision ? If there's some reason why maintenance is
easier , can you explain it ? That's typically how we make decisions in
this community there needs to be a clear reason to do something.

> If we do this split, you are more than welcome to demonstrate the
> commonality by modernizing mach-msm, combining it with mach-qcom,
> removing mach-msm, and then removing all the "confusion."

Thanks, why not get it right the first time..

Daniel


