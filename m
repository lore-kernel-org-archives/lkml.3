Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaGSR7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:59:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39484 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755317AbaGSR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:59:03 -0400
Date: Sat, 19 Jul 2014 13:59:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benson Leung <bleung@chromium.org>
cc: Dmitry Torokhov <dtor@google.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, <linux-pm@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <CANLzEkt4g_Y+nC6PSFCch6hR6YSE-S6FBe0Rt=adgWBi3vjM8Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407191357140.28179-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Benson Leung wrote:

> > This raises an interesting question.  Suppose the system gets suspended
> > while the lid is closed.  At that point, shouldn't wakeup devices be
> > enabled, even if they were already inhibited?
> 
> It's possible that this could be a policy decision, ie, whether
> power/wakeup is set to enabled for those devices or not.
> However, I'd say that there's only one policy that makes sense in that
> case : wakeups should be disabled while suspended.
> 
> If we inhibited the device during runtime to prevent stray input
> events from being generated, it wouldn't make sense to allow the
> device to potentially generate an accidental wakeup while suspended.

That doesn't really make sense.  If you're afraid of a device 
generating spurious wakeup events when the lid is closed, you should 
never enable it for wakeup.  After all, one of the first things that 
people often do after suspending their laptop is close the lid.

Alan Stern

