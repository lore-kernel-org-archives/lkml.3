Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3JaRMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:12:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58771 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3JaRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:12:07 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
	<1382993006-27359-3-git-send-email-davidb@codeaurora.org>
	<20131029132043.GA28165@fifo99.com>
	<CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
	<87ob66nyqc.fsf@linaro.org> <20131030232412.GA10229@fifo99.com>
Date: Thu, 31 Oct 2013 10:12:03 -0700
In-Reply-To: <20131030232412.GA10229@fifo99.com> (Daniel Walker's message of
	"Wed, 30 Oct 2013 16:25:32 -0700")
Message-ID: <8738nhnz4s.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> writes:

> On Wed, Oct 30, 2013 at 04:08:27PM -0700, Kevin Hilman wrote:
>> Olof Johansson <olof@lixom.net> writes:
>> 
>> > I would be very happy to take more code for the older Qualcomm chipset
>> > to enable full functionality for them, but it's been my impression
>> > that far from all that is needed to make it a useful platform is in
>> > the upstream kernel, and there's been no signs of more of it showing
>> > up at least in the last two years.
>> >
>> > So we have a bit of a stalemate here -- the current Qualcomm team
>> > wants to avoid having to deal too much with the legacy platforms --
>> > they are technically quite different from the current platforms and
>> > the divergence makes it hard to deal with supporting it all in a
>> > modern way without risking regressions. I tend to agree with them.
>> 
>> As do I.
>> 
>> > Just like omap split between omap1 and omap2plus, I think it's a time
>> > to create a mach-qcom instead, and move the modern (v7, most likely)
>> > platforms there -- enable them with device tree, modern framework
>> > infrastructure, etc. That way you can keep older platforms in mach-msm
>> > without risk of regressions, and they have a clean base to start on
>> > with their later platforms.
>> 
>> I think this split approach is a good compromise.
>> 
>> If the maintainers of the current older platforms wish to bring them up
>> to modern frameworks, we can consider combining again.  If not, they the
>> older platforms will take the same path as the rest of the older
>> platforms that slowly fade away.
>> 
>
> So the current users of those platforms are, what SOL ?

No.  The idea behind splitting them is to allow current platforms with
active maintainers to progress without being held back.  The older
platforms can stay and have an opportunity to modernize. 

The kernel is a moving target, without some minimal effort to keep
platforms up to date, the effort to continue to maintain/modernize them
can become more of a pain than it's worth.  If maintainers of these older
platforms are willing to put in the work, nobody will be SOL.  If
nobody shows interest in modernizing these older platforms (which seems
to be the case based on the last couple years), then it is reasonable
IMO for them to fade away slowly.

Kevin


