Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaGPVgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:36:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbaGPVge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:36:34 -0400
Message-ID: <1405546565.23419.3.camel@linux-fkkt.site>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
From: Oliver Neukum <oneukum@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dtor@google.com>, Patrik Fimml <patrikf@chromium.org>,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1407161400150.1028-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1407161400150.1028-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jul 2014 23:36:05 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:08 -0400, Alan Stern wrote:
> > I am not so much concerned about userspace, but about reusing of as
> > much of existing PM framework in the drivers. Right now it is very
> > hard to correctly track dependencies between general open/close,
> > system suspend/resume, and various runtime-PM transitions. Adding
> yet
> > another PM mechanism into the mix will just add more complexity.
> 
> Would it make sense to unbind the drivers for these devices when the 
> lid is closed?  With the drivers gone, there would naturally be no 

No, because I don't want settings of my devices to disappear.
You can do that only for stateless devices. And I doubt you can
tell in general which devices are stateless.

	Regards
		Oliver


