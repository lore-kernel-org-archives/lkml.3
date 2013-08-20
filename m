Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3HTWtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:49:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46189 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396Ab3HTWtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:49:46 -0400
Message-ID: <1377038985.2016.96.camel@joe-AO722>
Subject: Re: rfc: trivial patches and slow deaths?
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Tue, 20 Aug 2013 15:49:45 -0700
In-Reply-To: <20130820152456.c12dd8f543e2735b6952ae13@linux-foundation.org>
References: <1376944033.2016.13.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
	 <1376946644.2016.35.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192315000.21654@pobox.suse.cz>
	 <1376947637.2016.39.camel@joe-AO722> <1377028944.2737.75@driftwood>
	 <1377029650.2016.72.camel@joe-AO722> <1377035369.2737.85@driftwood>
	 <1377036678.2016.88.camel@joe-AO722>
	 <20130820152456.c12dd8f543e2735b6952ae13@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 15:24 -0700, Andrew Morton wrote:
> On Tue, 20 Aug 2013 15:11:18 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Andrew?  Do you want to handle patches for defects that
> > are both obvious _and_ trivial?
> 
> I look at everything!

Well, I guess I'll have to start cc'ing you on
the trivial in case the eyestrain gets to you.

[]

> I somewhat disagree that even
> https://patchwork.kernel.org/patch/2833648/ was trivial.  It changes
> the format of kernel logs and might have implications for people who
> are parsing those logs.

I think there are _very_ few instances where dmesg
output should be kept constant for scrapers.

The format of an oops is about the only one I can
think of where it's reasonable to do so.

> one needs to read each and every
> conversion and decide on the risk factor.

Enjoy...

