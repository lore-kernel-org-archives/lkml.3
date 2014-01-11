Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaAKSvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:51:17 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:38380 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaAKSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:51:13 -0500
Date: Sat, 11 Jan 2014 13:51:10 -0500
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET v2 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140111185110.GB3257@mtj.dyndns.org>
References: <20140110135416.GA8752@htj.dyndns.org>
 <Pine.LNX.4.44L0.1401101042010.1399-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401101042010.1399-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Alan.

On Fri, Jan 10, 2014 at 10:46:10AM -0500, Alan Stern wrote:
> The SUBJECT lines in your patch emails don't mention the version
> number.  That is, they just say "[PATCH]", not "[PATCH v2]" or "[PATCH
> v3]". This makes it very difficult for me to tell which messages to
> read.

Hmm... they're all threaded.  I add version tags when posting
incremental patches but usually don't bother with it when posting a
new version of the whole series.  After all, some patches are get
updated without explicitly given a new version for refrehses and stuff
so it's not like you can determine everything based on subjects only.

> (Reading them in order doesn't work, because my computer mixes up the 
> order of messages when it downloads a large bunch from the email 
> server.  It's kind of annoying...)

And they aren't threaded?

Thanks.

-- 
tejun
