Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3CTPPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:15:13 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41783 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:15:12 -0400
Subject: Re: linux-next: build failure after merge of the tty tree
To: jslaby@suse.cz (Jiri Slaby)
Date: Wed, 20 Mar 2013 11:15:11 -0400
Cc: sfr@canb.auug.org.au (Stephen Rothwell), greg@kroah.com (Greg KH),
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5149D1FD.90400@suse.cz>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130320151511.170EC8017A@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby writes:
> 
> On 03/20/2013 03:42 PM, Bill Pemberton wrote:
> > Ok, for the unopened ports there *should* never be any actual data to
> > push so the push is really doing nothing anyhow in these cases.  It's
> > coming from the device sending an initial change port command.
> > 
> > Anyhow, so my patch adding more is_open logic can be dropped and then
> > yours will apply fine.  What's the best way for me to handle this?
> > Send a revert for my patch so yours will apply or send an updated
> > version of your patch that removes my additions?
> 
> Asking Greg to revert should suffice. I commented on that patch, but in
> a different thread, so Greg missed the comment the patch is not needed
> IIRC. What was the title of the patch, I cannot find it immediately :/?
> 

"USB: quatech2: only write to the tty if the port is open." (commit
27b351c in v3.9-rc3).

-- 
Bill
