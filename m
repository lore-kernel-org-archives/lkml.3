Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3CTPUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:20:17 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42458 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3CTPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:20:15 -0400
Message-ID: <5149D1FD.90400@suse.cz>
Date: Wed, 20 Mar 2013 16:13:01 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
References: <20130320144233.10125800E4@viridian.itc.virginia.edu>
In-Reply-To: <20130320144233.10125800E4@viridian.itc.virginia.edu>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 03:42 PM, Bill Pemberton wrote:
> Ok, for the unopened ports there *should* never be any actual data to
> push so the push is really doing nothing anyhow in these cases.  It's
> coming from the device sending an initial change port command.
> 
> Anyhow, so my patch adding more is_open logic can be dropped and then
> yours will apply fine.  What's the best way for me to handle this?
> Send a revert for my patch so yours will apply or send an updated
> version of your patch that removes my additions?

Asking Greg to revert should suffice. I commented on that patch, but in
a different thread, so Greg missed the comment the patch is not needed
IIRC. What was the title of the patch, I cannot find it immediately :/?


-- 
js
suse labs
