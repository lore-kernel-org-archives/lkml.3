Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbaGOH5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:57:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48809 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaGOH5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:57:32 -0400
Date: Tue, 15 Jul 2014 10:57:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH 7/8] staging: dgap: introduce dgap_cleanup_nodes()
Message-ID: <20140715075717.GH23001@mwanda>
References: <20140715030402.GA14411@devel.8.8.4.4>
 <20140715064125.GQ25880@mwanda>
 <CAHb8M2CoFhQAwRc5cKqkK4zq77yM6n_8r_jvU+MwHYLWyHosxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2CoFhQAwRc5cKqkK4zq77yM6n_8r_jvU+MwHYLWyHosxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:32:27PM +0900, DaeSeok Youn wrote:
> 2014-07-15 15:41 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Tue, Jul 15, 2014 at 12:04:02PM +0900, Daeseok Youn wrote:
> >> When a configration file is parsed with dgap_parsefile(),
> >> makes nodes for saving configrations for board.
> >>
> >> Making a node will allocate node memory and strings for saving
> >> configrations with kstrdup().
> >>
> >> So these are freed when dgap is unloaded or failed to initialize.
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >> It MUST be needed to prevent memory leaks but
> >> I'm not sure that I fix properly.
> >>
> >> Please review.
> >
> > This thread doesn't have Mark on the CC list and he's the only person
> > who can actually test it properly.  Resend it and CC Mark
> > Hounschell <markh@compro.net>.
> 
> Really? I'd added Mark to CC list.
> hmm.. In your reply doesn't have Mark. I was checking sent-box, he is
> in the CC list.
> 
> OK. I will try to send this again after fixing 6/7 and 8/8.
> Thanks.

None of them have Mark CC'd except for the I added him to the reply
about pr_err().  I knew you said you were CC'ing him so I figured
something weird was going on...

regards,
dan carpenter

