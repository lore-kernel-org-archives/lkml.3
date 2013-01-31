Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3AaRTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:19:06 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:63258 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaRTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:19:04 -0500
MIME-Version: 1.0
In-Reply-To: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
Date: Thu, 31 Jan 2013 18:19:01 +0100
Message-ID: <CABPqkBSdpYXZi+Jzyo2A94DHE9oZxsXKL_c8oGSf1KF=_q0Prg@mail.gmail.com>
Subject: Re: Basic perf PMU support for Haswell v1
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

Are you going to post a new version based on my feedback or do you stay
with what you posted on 1/25?


On Fri, Jan 25, 2013 at 11:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> This is based on v7 of the full Haswell PMU support, but
> ported to the latest perf/core and stripped down to the "basic support"
> as requested.
>
> I decided to include LBRs in the basic support. These are 4 patches
> self contained at the end, so could be also handled as a separate
> unit if that is preferable.
>
> Contains support for:
> - Basic Haswell PMU and PEBS support
> - Late unmasking of the PMI
> - Support for wide counters
> - New TSX counter flags, exported as sysfs attributes
> - Support for checkpointed counters.
> - New LBR flags, exported as new flags with tools support
>
> Available from
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc hsw/pmu4-basics
>
> For more details on the Haswell PMU please see the SDM. For more details on TSX
> please see http://halobates.de/adding-lock-elision-to-linux.pdf
>
> -Andi
