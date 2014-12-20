Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaLTWtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:49:21 -0500
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:41333
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187AbaLTWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:49:17 -0500
Date: Sat, 20 Dec 2014 22:46:07 +0000
From: dwalker@fifo99.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: ***UNCHECKED*** Re: [PATCH] arch: arm: mach-msm: smd.c: Remove
 some unused functions
Message-ID: <20141220224607.GA4466@fifo99.com>
References: <1417914740-8390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <CAFo99gbPKw4uHY_QqyZ495O9QLKL69HQyJmQUKNaGQTNqsG-mw@mail.gmail.com>
 <20141218220128.GA10615@fifo99.com>
 <6909946.FWqDZQSxq2@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6909946.FWqDZQSxq2@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 11:35:04PM +0100, Arnd Bergmann wrote:
> On Thursday 18 December 2014 22:01:28 dwalker@fifo99.com wrote:
> > On Tue, Dec 16, 2014 at 12:20:43AM +0100, Rickard Strandqvist wrote:
> > > Hi
> > > 
> > > My script looks for the same function name, so if they then would be
> > > named exactly the same, they would come up.
> > > 
> > > But I can not even find drivers/staging/dream/   or is this really new code?
> > 
> > Maybe it was deleted already ..
> 
> It's been gone for over four years, after nobody worked on cleaning it up
> for a while before that:
> 
> commit 3414df8ca38b203c8a5ad8efc32d4a3836a0596d
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Fri Oct 29 12:42:18 2010 -0700
> 
>     Staging: dream: remove dream driver and arch from tree
>     
>     This code is stalled, with no one working on it anymore, and the main
>     msm code is now going through the proper channels to get merged
>     correctly.
>     
>     So remove it as it contains a number of kernel information leaks and it
>     is doubtful if it even still builds anymore.
>     
>     Acked-by: Pavel Machek <pavel@ucw.cz>
>     Acked-by: Bryan Huntsman <bryanh@codeaurora.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


Yeah, somehow still ended up in my 3.18 tree. Must have been a "git reset".

Daniel

