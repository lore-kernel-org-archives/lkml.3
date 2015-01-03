Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbbACTCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 14:02:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbACTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 14:02:20 -0500
Date: Sat, 3 Jan 2015 20:02:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, edubezval@gmail.com, rui.zhang@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cleanup ti-soc-thermal
Message-ID: <20150103190218.GA6814@amd>
References: <20150103111904.GA11545@amd>
 <20150103174804.GA20341@kahuna>
 <20150103185130.GA5950@amd>
 <54A83B80.1020508@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A83B80.1020508@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2015-01-03 12:57:04, Nishanth Menon wrote:
> On 01/03/2015 12:51 PM, Pavel Machek wrote:
> >On Sat 2015-01-03 11:48:04, Nishanth Menon wrote:
> >>On 12:19-20150103, Pavel Machek wrote:
> >>>Simplify code by removing goto's where they point to simple return.
> >>>
> >>>Avoid confusing |= on error values.
> >>
> >>Please split these up into chunks of related changes. there is white
> >>space and quiet a few other changes all mixed in.
> >
> >Do you believe that the patch is too big to be understood? I don't
> >think it is.
> >
> >It is four screens, and it is pretty obvious it does not change any
> >code.
> 
> It basic patch generation stuff - where you are being nice to the reviewer.
> When you are doing functional changes, at least drop out or at the very
> least mention that there are white space changes in your patch
> submission.

Original submission said:

# Correct whitespace.

Some maintainers actually hate separate whitespace changes; talk to Al
Viro some day.

> I dont care too much to review stuff where I have to look at multiple
> changes in a single patch - trivial or not. Sorry.. just a waste of my time.

If 4 screens of trivial changes are too much for you, don't review
trivial patches, then. It is not your job.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
