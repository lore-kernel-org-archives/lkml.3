Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaLTAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:16:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaLTAQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:16:26 -0500
Date: Sat, 20 Dec 2014 01:16:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: =?utf-8?B?7J207KKF7ZmU?= <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        =?utf-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: Re: [PATCH RESEND v2 03/10] power: charger-manager: Remove
 deprecated function, cm_notify_event().
Message-ID: <20141220001622.GA1694@amd>
References: <1255984171.39711418975524329.JavaMail.weblogic@epmlwas08d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255984171.39711418975524329.JavaMail.weblogic@epmlwas08d>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-19 07:52:07, MyungJoo Ham wrote:
> >   
> >  cm_notify_event() is introduced to get event associated with battery status
> > externally, but no one had been used. Moreover it makes charger manager
> > driver more complicated. This patch tries to drop the function and all data
> > related to simplify the driver.
> > 
> > Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> You are not just removing cm_notify_event() and its related.
> 
> You are hereby removing the much of software charger control
> and suspend-related operations. Could you please be more specific
> on why? (many of such features are to comply with operators' requirements)
> 
> (Or we may meet next Monday for some discussions :) )

So... you'll meet in person and we will not see fireworks on the
mailing list? :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
