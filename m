Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaCDLQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:16:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38784 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932111AbaCDLQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:16:25 -0500
Date: Tue, 4 Mar 2014 11:15:21 +0000
From: Will Deacon <will.deacon@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Joe Perches <joe@perches.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
Message-ID: <20140304111520.GE8766@mudshark.cambridge.arm.com>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
 <1393899715.20435.8.camel@joe-AO722>
 <53153A4C.9050602@infradead.org>
 <CACxGe6tD3mQshDSoEQaPXAnXG_siUdiFoAWhjmO2gDY7ZzkjUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tD3mQshDSoEQaPXAnXG_siUdiFoAWhjmO2gDY7ZzkjUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:59:46AM +0000, Grant Likely wrote:
> On Tue, Mar 4, 2014 at 10:28 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 03/03/2014 06:21 PM, Joe Perches wrote:
> >> On Tue, 2014-03-04 at 10:15 +0800, Graeme Gregory wrote:
> >>> Add maintainers for the arm-core file for arm64 ACPI support
> >>
> >> Shouldn't something have to be in the kernel
> >> tree before there's a MAINTAINERS entry?
> >
> > or in linux-next and the patch can be added to linux-next (some git tree).
> 
> Sure, it makes sense to merge this file along with the rest of the
> series, but I certainly appreciate that Graeme and Hanjun are willing
> to volunteer to do this work.

Well, to put it another way, it makes no sense at all to merge this patch
independently.

> On Tue, Mar 4, 2014 at 6:23 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Mar 04, 2014 at 02:15:45AM +0000, Graeme Gregory wrote:
> >> +ACPI ARM64
> >
> > That's a pretty broad statement for a single file. Is it core support,
> > architected peripherals, SoC?
> 
> That's a good point. Graeme, it would be good if you could put some
> text in the patch describing how you propose the maintainership to
> work. Unfortunately the maintainers file doesn't have any kind of
> comments field, otherwise I'd suggest you make those comments directly
> there.
> 
> Given that ACPI can touch a lot of subsystems I would expect you and
> Hanjun not to be merging much code directly, but being listed in
> maintainers means that you will be kept in the loop when it comes to
> merging ARM ACPI changes. I would also expect that anything that does
> go through you (instead of merely acked) would be merged via Rafael
> and Len's tree.
> 
> >
> >> +M:   Hanjun Guo <hanjun.guo@linaro.org>
> >> +M:   Graeme Gregory <graeme.gregory@linaro.org>
> >> +S:   Supported
> >> +L:   linux-acpi@vger.kernel.org
> >> +F:   drivers/acpi/plat/arm-core.c
> >
> > This patch should be part of the series introducing the arm-core.c file
> > and it will be ACKed (or NAKed) following review. We can't really commit
> > maintainers to a file which does not exist in mainline and while there is
> > still feedback to be addressed. It's like a blank cheque.
> 
> I agree with merging it with the rest of the series, but comparing it
> to a blank cheque is not appropriate. Merely having an entry in
> MAINTAINERS doesn't immediately confer trust or ability to merge code,
> but it does tell people who to talk to when looking at ACPI on ARM.
> You can bet that neither Linus, Len or Rafael will merge ARM ACPI
> trees from them if you disagree. (And even if they did, you would
> yell, and Linus would revert it).

If you want to know who to talk to regarding a subsystem then you use
get_maintainer.pl and/or git blame. Regardless of this patch, neither of
those tools will identify Graeme or Hanjun as the contacts for ACPI on ARM.

I think we're in agreement, but just to spell it out: this patch should be
included at the end of a series adding the files which will be maintained.

Will
