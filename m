Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaKDNPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:15:05 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63339 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKDNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:15:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140901135129.GN27892@worktop.ger.corp.intel.com>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
	<1409006611-30741-4-git-send-email-andi@firstfloor.org>
	<20140901135129.GN27892@worktop.ger.corp.intel.com>
Date: Tue, 4 Nov 2014 14:14:59 +0100
Message-ID: <CABPqkBTn5cFNWSmbCnUPepOTyO2sx5ch=-=kbzfG+n2HU5pftA@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What's happening with Broadwell support?
I don't see any support in 3.18-rc2. We need
this ASAP now.


On Mon, Sep 1, 2014 at 3:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Aug 25, 2014 at 03:43:29PM -0700, Andi Kleen wrote:
>
>> +     case 61: /* Broadwell Client */
>
> Again, no other description has "Client" in.
