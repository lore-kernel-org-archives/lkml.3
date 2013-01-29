Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3A2AbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:31:25 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41935 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3A2AbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:31:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130128234620.GA8524@localhost>
References: <510441ca.jKKGS3DOYyOC3gnk%fengguang.wu@intel.com>
	<20130127010632.GF12329@localhost>
	<CABPqkBR4VCOpBH25yQOnhkOs6c52xEnNe=P4qifDXzr7WBERxw@mail.gmail.com>
	<20130128234620.GA8524@localhost>
Date: Tue, 29 Jan 2013 01:31:19 +0100
Message-ID: <CABPqkBS4Y7y4OPH_5XYcrupGfRat9whT=3B8Fpyo7KuBAHDFfg@mail.gmail.com>
Subject: Re: [PATCH tip] perf/x86: nhm_events_attrs and snb_events_attrs can
 be static
From: Stephane Eranian <eranian@google.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:46 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- linux-next.orig/arch/x86/kernel/cpu/perf_event_intel.c      2013-01-29 07:42:16.238595053 +0800
> +++ linux-next/arch/x86/kernel/cpu/perf_event_intel.c   2013-01-29 07:43:47.678597226 +0800
> @@ -139,12 +139,12 @@ static struct extra_reg intel_snb_extra_
>  EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
>  EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
>
> -struct attribute *nhm_events_attrs[] = {
> +static struct attribute *nhm_events_attrs[] = {
>         EVENT_PTR(mem_ld_nhm),
>         NULL,
>  };
>
> -struct attribute *snb_events_attrs[] = {
> +static struct attribute *snb_events_attrs[] = {
>         EVENT_PTR(mem_ld_snb),
>         NULL,
>  };
