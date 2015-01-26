Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbbAZMkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:40:11 -0500
Received: from 8bytes.org ([81.169.241.247]:46374 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbbAZMkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:40:08 -0500
Date: Mon, 26 Jan 2015 13:40:06 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150126124005.GC4653@8bytes.org>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
 <20150123170243.GG22635@pd.tnic>
 <20150126121142.GG30345@8bytes.org>
 <20150126122017.GA1656@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126122017.GA1656@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:20:17PM +0100, Borislav Petkov wrote:
> On Mon, Jan 26, 2015 at 01:11:42PM +0100, Joerg Roedel wrote:
> > Or we solve it in user-space by some more cleverness in creating the
> > kernel command-line for crashkernel=high.
> 
> I'd say, we should try to do as much as possible automatically.

Thats hard to do, without any information about the driver needs we only
have the amount of devices in the system to base any heuristic on.

> > But besides that, I think the first two patches of this set make sense
> > anyway. I understand that the third one is debatable.
> 
> Right, but since they fix a real problem, maybe we should take them now
> until a better fix is done? Yes, no?

Yes. Given that we have no data about what would work on most
systems, we can only change the value to a number that fixes know
problems and then act on possible regressions caused by the change (and
that change is pretty easy to revert if needed).


	Joerg

