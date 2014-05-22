Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaEVHKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:10:23 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50217 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbaEVHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:10:22 -0400
Message-ID: <1400742620.21254.22.camel@x220>
Subject: Re: [PATCH] powerpc: fix typo 'CONFIG_PMAC'
From: Paul Bolle <pebolle@tiscali.nl>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 09:10:20 +0200
In-Reply-To: <874n0j3yjf.fsf@igel.home>
References: <1400617498.4912.66.camel@x220> <874n0j3yjf.fsf@igel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 07:10:21.0541 (UTC) FILETIME=[E507F950:01CF758C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Wed, 2014-05-21 at 18:08 +0200, Andreas Schwab wrote:
> Paul Bolle <pebolle@tiscali.nl> writes:
> 
> > Commit b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling
> > perf_event_do_pending") added a check for CONFIG_PMAC were a check for
> > CONFIG_PPC_PMAC was clearly intended.
> >
> > Fixes: b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling perf_event_do_pending")
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested. Needs testing on 32 bit powermac, I guess.
> >
> > This typo was introduced in v2.6.36. No one noticed because very few
> > people still use 32 bit powermacs?
> 
> How does that bug manifest itself?

Do you want to know how to test this patch on a 32 bit powermac? Ie, see
if it has any effect, and whether that effect improves things or make
things worse.

I have no clue how to do that, sorry. Perhaps someone else has.


Paul Bolle

