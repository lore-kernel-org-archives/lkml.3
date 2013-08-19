Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3HSV1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:27:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45317 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750925Ab3HSV1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:27:19 -0400
Message-ID: <1376947637.2016.39.camel@joe-AO722>
Subject: Re: rfc: trivial patches and slow deaths?
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Mon, 19 Aug 2013 14:27:17 -0700
In-Reply-To: <alpine.LNX.2.00.1308192315000.21654@pobox.suse.cz>
References: <1376944033.2016.13.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz>
	 <1376946644.2016.35.camel@joe-AO722>
	 <alpine.LNX.2.00.1308192315000.21654@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 23:22 +0200, Jiri Kosina wrote:
> On Mon, 19 Aug 2013, Joe Perches wrote:
> 
> > This is a 7 line patch that corrects logging defects that has had no 
> > reply from you for the last month.
> > 
> > https://patchwork.kernel.org/patch/2833648/
> 
> This hasn't missed any Linus' major release, as it has been submitted post 
> 3.11 merge, right? (hint, that was Jul 4th).
> 
> If this would miss *next* major Linus' release, I would accept your 
> complaints. But this is definitely not the case.

You're suggesting this patch, which corrects obvious
defects, should miss 3.12 and go into 3.13?

I think that's wrong.

I think it should be in -next now.  It's not.

What should any patch submitter expect about
visibility and/or knowledge of the applicability
of this sort of patch from trivial?


