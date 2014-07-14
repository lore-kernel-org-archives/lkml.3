Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaGNRJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:09:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28798 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaGNRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:41 -0400
Date: Mon, 14 Jul 2014 20:09:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH V2 1/4] staging: vt6556: Cleanup coding style issues
Message-ID: <20140714170927.GF23001@mwanda>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
 <20140713193647.GA31010@kroah.com>
 <20140714085932.GA2958@hp-peter.rsr.lip6.fr>
 <20140714141231.GM25880@mwanda>
 <CA+MoWDpQBQYqZ2ZLM3-17cfQQ0LjMcv702ZxVv10M5Wd895rJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDpQBQYqZ2ZLM3-17cfQQ0LjMcv702ZxVv10M5Wd895rJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 07:01:37PM +0200, Peter Senna Tschudin wrote:
> <note>
> I'm not trying to push my changes over the rules. I'm trying to
> understand the problem, to avoid creating similar noise in the future.
> </note>
> 
> Now I understand that the problem with the series of 4 patches is that
> the subject is the same on the 4 patches. Having the same subject in 4
> patches is not good. I got this one.
> 
> But I have no clue why joining 4 cleanup patches into 1 is bad. The
> patches are all for the same driver, are all silencing checkpatch
> warnings, and even the typedef stuff was reported by checkpatch. The
> commit message of the single patch describes it all. If the subject of
> the series is the problem, why not make a single patch instead of a
> series of similar patches? It made sense from my perspective. So what
> is the problem in re-submit 4 similar patches as a single patch?

The one thing per patch rule is a bit ambiguous, but normally we auto
reject patches which "fix every checkpatch warning in somefile_foo.c"
and sugest that they instead be broken into one type of fix per patch.

Breaking it up like this is maybe not always beautiful but it's simple
to explain to newbies and generally easier to review.

If there are very few warnings in the file then "fix everything" is ok.

regards,
dan carpenter

