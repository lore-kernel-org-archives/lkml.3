Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaIPIvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:51:37 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57954 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaIPIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:51:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140915155837.GR5387@tassilo.jf.intel.com>
References: <20140915143832.GA3264@quad>
	<20140915155837.GR5387@tassilo.jf.intel.com>
Date: Tue, 16 Sep 2014 10:51:33 +0200
Message-ID: <CABPqkBSw1CUwULMhXbSEYYjYxNih=Yf+uR0pezcdv6VhFtFUWw@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: update support for client uncore IMC PMU
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Liang, Kan" <kan.liang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 5:58 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> On Mon, Sep 15, 2014 at 04:38:32PM +0200, Stephane Eranian wrote:
> >
> > This patch restructures the memory controller (IMC) uncore
> > PMU support for client SNB/IVB/HSW processors. The main change
> > is that it can now cope with more than one PCI device ID per
> > processor model. There are many flavors of memory controllers
> > for each processor. They have different PCI device ID, yet
> > they behave the same w.r.t. the memory controller PMU that
> > we are interested in.
> >
> > The patch now supports two distinct memory controllers for IVB
> > processors: one for mobile, one for desktop.
>
> I haven't investigated yet, but on my Lenovo ULT Haswell laptop
> the IMC PCI-ID doesn't exist, so the driver doesn't initialize.
>
Send me the PCI-ID for this memory controller and I will add it
to V2 of the patch.
Thanks.
