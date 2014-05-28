Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaE1OGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:06:37 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58446 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaE1OGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:06:35 -0400
Date: Wed, 28 May 2014 18:06:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140528140632.GH2570@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140528135617.GA25750@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528135617.GA25750@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:56:17PM +0200, Pavel Machek wrote:
> Hi!
> 
> > So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> > 
> > It crashes more or less instantly (sorry for the line wrapping, 
> > just got the serial console hooked up and don't have minicom configured 
> > right yet).
> > 
> > this is 3.15-rc4 with the anti-memory corruption patch applied.
> > 
> > [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> > [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
> 
> Pentium 4 's were not 64bit, were they?

Not all, but there were 64bit varians (Xeons iirc).
