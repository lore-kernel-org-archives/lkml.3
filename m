Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3GOUTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:19:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48939 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3GOUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:19:44 -0400
Date: Mon, 15 Jul 2013 13:19:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130715201943.GA22131@roeck-us.net>
References: <1373916476.2748.69.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373916476.2748.69.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
[ ... ]
> 
> The solution, to me, looks simple:  Let's co-opt a process we already
> know how to do: mailing list review and tree handling.  So the proposal
> is simple:
> 
>      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
>         reviewed patch to stable

That seems to be a bit drastic. It is quite useful to have the tag,
but maybe it should only be added by the maintainer and not in the initial
patch submission. This would ensure that the maintainer(s) made the decision.
If the original patch submitter thinks that the patch is stable material,
that information could be added in the comments section.

This would also ensure that patches are not accidentially sent to the stable
mailing list prior to being accepted into the upstream kernel, and if necessary
triggers a discussion on the subject mailing list if the patch is stable
material or not - which addresses points 2 and 3 below.

Guenter

>      2. All patches to stable should follow current review rules: They
>         should go to the mailing list the original patch was sent to
>         once the original is upstream as a request for stable.
>      3. Following debate on the list, the original maintainer would be
>         responsible for collecting the patches (including the upstream
>         commit) adjudicating on them and passing them on to stable after
>         list review (either by git tree pull or email to stable@).
> 
> I contend this raises the bar for adding patches to stable much higher,
> which seems to be needed, and adds a review stage which involves all the
> original reviewers.
> 
> Oh, and did someone mention plum brandy ...?
> 
> James
> 
> 
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss
