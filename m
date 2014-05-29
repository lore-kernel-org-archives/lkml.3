Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbaE2INd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:13:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38864 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbaE2INa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:13:30 -0400
Date: Thu, 29 May 2014 09:10:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [for-next][PATCH] ftrace: Make CALLER_ADDRx macros more generic
Message-ID: <20140529081036.GF29812@arm.com>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862353-28963-7-git-send-email-takahiro.akashi@linaro.org>
 <20140416135217.GF1001@arm.com>
 <535E3040.7090402@linaro.org>
 <20140527091019.54a8d2d6@gandalf.local.home>
 <20140527184940.GA26035@arm.com>
 <5386C543.6070104@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386C543.6070104@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:27:31AM +0100, AKASHI Takahiro wrote:
> Hi Will

Hi Akashi,

> On 05/28/2014 03:49 AM, Will Deacon wrote:
> > On Tue, May 27, 2014 at 02:10:19PM +0100, Steven Rostedt wrote:
> >> Will,
> >>
> >> I made a separate branch called ftrace/arm64 as shown below. You can
> >> pull that branch to base the rest of Akashi-san's patches on top of it.
> >> The branch is based on top of v3.15-rc5.
> >
> > Thanks Steve, I'll pull that in.
> >
> > Akashi: please can you re-send your series, based on the branch below and
> > including the acks/reviewed-by tags you got for v6 of the patches?
> 
> Sorry again to have missed your e-mail :-)

You should fix your filters!

> I'm sure that you can successfully apply all my patch series, without any
> modification, from:
>      v6 arm64: prerequisites for audit and ftrace
>      v8 arm64: Add ftrace support
> except for the patch, "[v8 1/8] ftrace: make CALLER_ADDRx macros more generic,"
> which was replaced by a new version and already appears in Steven's repo.

Yeah, you're right, I've managed to pick patches 2-8 from that posting --
thanks.

Will
