Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaLFMrN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 07:47:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48445 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaLFMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 07:47:10 -0500
Date: Sat, 6 Dec 2014 13:47:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: Disable input device
Message-ID: <20141206124708.GA17289@amd>
References: <201411291824.03996@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411291824.03996@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-11-29 18:24:03, Pali Rohár wrote:
> Hello,
> 
> there is request to introduce some option (via sysfs) to disable 
> one input device. Originally it was for tsc2005 touchscreen found 
> on Nokia N900 cellphone. Use case is to completely disable 
> touchscreen when phone is in pocket or when screen is locked via 
> slide switch (to prevent random clicks).
> 
> But it would be better to have disable option for all input 
> devices. Sometimes input device is not use and only consume 
> power. Another case is when input device (e.g. keyboard or 
> touchpad) is integrated into machine (e.g. on laptops) and user 
> does not want to use it (so make sure that kernel does not send 
> events to userspace).
> 
> I would like to ask, how to solve it?
> 
> What do you think about adding new sysfs file "disable" (accept 
> values 1 or 0) for every input device? With "1" it cause that 
> kernel will drop all events from specific input device and if 
> driver provide some function is can be called (e.g. for power 
> management or disabling device at hardware level).

That makes sense to me. Dmitry, would such interface be acceptable?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
