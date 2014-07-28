Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaG1PrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:47:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32987 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbaG1PrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:47:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19b6tUycDCmCTh+t9awLJlpLuee28a22/I=
X-DKIM: OpenDKIM Filter v2.0.1 titan 328395B87EA
Date: Mon, 28 Jul 2014 11:46:55 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Liviu I." <liviu.i.2222@gmail.com>, gregkh@linuxfoundation.org,
        amk@cray.com, liang.zhen@intel.com, uja.ornl@gmail.com,
        emoly.liu@intel.com, rashika.kheria@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Eudyptula Challenge (Task 10)
Message-ID: <20140728154655.GV23220@titan.lakedaemon.net>
References: <20140728071332.GA3822@gmail.com>
 <20140728125319.GA537@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728125319.GA537@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 05:53:19AM -0700, Christoph Hellwig wrote:
> Can you folks please stop this challenge Bullshit?  More checkpatch
> fixes is not something we'll need at all.

Greg and Dan have previously said that the staging tree is a good place
for newcomers to submit checkpatch cleanup patches.  However, I think
there are a few tweaks that could be made to the Eudyptula Challenge to
avoid this noise/frustration:

  - No need to send to lkml, the staging tree ML is probably fine.

  - Don't mention Eudyptula Challenge, it's not relevant to the patch.
     * It looks like you want a cookie.  We have none.

  - Submit the patch to the Challenge admins first for review.  This
    patch submission should have never made the cut.
     - No S-o-B
     - MIME attachment
     - Subject line is just wrong
     - Full name missing in From:

I've worked with several participants of the challenge and never saw
this many things wrong with a patch submission.  Either the admins are
dropping the ball, or this participant got loose somehow. :)

It makes me wonder if they should start with a git workflow from day
one?  It would prevent a lot of these avoidable mistakes.

thx,

Jason.
