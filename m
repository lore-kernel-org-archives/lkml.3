Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3HTOoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:44:07 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:49778 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3HTOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:44:04 -0400
Date: Tue, 20 Aug 2013 10:42:56 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: P J P <ppandit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About perf,arm -- oops in validate_event
In-Reply-To: <CAHkRjk76V-RyJbm4mSNt6DLpLDv_wqcuag5Z_hSTcrcdUi=6jg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1308201039570.14233@vincent-weaver-1.um.maine.edu>
References: <alpine.LFD.2.03.1308201522230.15482@erqung.pbz> <CAHkRjk76V-RyJbm4mSNt6DLpLDv_wqcuag5Z_hSTcrcdUi=6jg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Catalin Marinas wrote:

> On 20 August 2013 11:03, P J P <ppandit@redhat.com> wrote:
> >  -> https://lkml.org/lkml/2013/8/7/259
> >
> > I wanted to confirm if this above fix should also go into ARM64 build Or is
> > ARM64 platform not vulnerable?
> 
> It is and I'll push patches to mainline (Will is preparing them).

You'll probably also want the equivalent of 
    d9f966357b14e356dbd83b8f4a197a287ab4ff83
as well since arch/arm64/kernel/perf_event.c
has the same overflow in armpmu_map_event that is fixed in the mentioned
commit.

Vince
