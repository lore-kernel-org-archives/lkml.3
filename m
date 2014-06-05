Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaFEMpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:45:32 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51274 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFEMpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:45:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140604222857.GB16855@tassilo.jf.intel.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<20140604222857.GB16855@tassilo.jf.intel.com>
Date: Thu, 5 Jun 2014 14:45:29 +0200
Message-ID: <CABPqkBRKDBQFJ=nqggYJJrguU6iCyk6h5z1sO3_KNcZpgzbK2A@mail.gmail.com>
Subject: Re: [PATCH 0/9] perf/x86: implement HT counter corruption workaround
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 12:28 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> There is no HW or FW workaround for this problem.
>
> Actually there is for global measurements:
>
> measure with Any bit set and divide by two.
>
> Please add a check that the any bit is set, and disable
> the workaround for that case.
>
I think this assume same event is measured on sibling counters at any time.
Otherwise, how does that eliminate the corruption?
