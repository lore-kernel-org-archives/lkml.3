Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3JWUCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:02:02 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:43980 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3JWUB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:01:59 -0400
Date: Wed, 23 Oct 2013 17:01:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, thomas.ilsche@tu-dresden.de,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: Perf Python Scripting Leaks Memory
Message-ID: <20131023200149.GA6539@ghostprotocols.net>
References: <5267DF35.5010706@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267DF35.5010706@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 23, 2013 at 04:37:41PM +0200, Joseph Schuchart escreveu:
>    We are using the Python scripting interface in perf to extract kernel
>    events relevant for performance analysis of HPC codes. We noticed that the
>    "perf script" call allocates a significant amount of memory (in the order
>    of several 100 MiB) during it's run, e.g. 125 MiB for a 25 MiB input file:

Thanks for the analysis and the bug fix!

I asked Tom Zanussi and he kindly reviewed your patch and provided an
Acked-by tag for it, Tom, may I add a Reviewed-by: as well?

Joseph, can I have your Signed-off-by: tag, as documented in:

Documentation/SubmittingPatches

In the "12) Sign your work" section?

Thanks!

- Arnaldo
