Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3HTWY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:24:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3HTWY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:24:58 -0400
Date: Tue, 20 Aug 2013 15:24:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: rfc: trivial patches and slow deaths?
Message-Id: <20130820152456.c12dd8f543e2735b6952ae13@linux-foundation.org>
In-Reply-To: <1377036678.2016.88.camel@joe-AO722>
References: <1376944033.2016.13.camel@joe-AO722>
	<alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
	<1376946644.2016.35.camel@joe-AO722>
	<alpine.LNX.2.00.1308192315000.21654@pobox.suse.cz>
	<1376947637.2016.39.camel@joe-AO722>
	<1377028944.2737.75@driftwood>
	<1377029650.2016.72.camel@joe-AO722>
	<1377035369.2737.85@driftwood>
	<1377036678.2016.88.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 15:11:18 -0700 Joe Perches <joe@perches.com> wrote:

> Andrew?  Do you want to handle patches for defects that
> are both obvious _and_ trivial?

I look at everything!  If I like it and see that Jiri was cc'ed I try
to remember to cc him on the commit.

> > If it's trivial it's not time critical. If it's time critical it's not  
> > trivial.
> 
> We disagree on the definition of trivial.
> Trivial can also mean simple and immediately evident.

I find that I often remove "trivial" from changelogs and titles.  Patches
which are marked thus are often non-trivial and merit a bit of thought.


For example, I somewhat disagree that even
https://patchwork.kernel.org/patch/2833648/ was trivial.  It changes
the format of kernel logs and might have implications for people who
are parsing those logs.  Unlikely, but one needs to read each and every
conversion and decide on the risk factor.


