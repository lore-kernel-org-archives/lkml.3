Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaLZWOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 17:14:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaLZWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 17:14:47 -0500
Date: Fri, 26 Dec 2014 23:14:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: ivo.welch@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: fanotify bug on gdb -- hard crash
Message-ID: <20141226221444.GA13349@amd>
References: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-26 22:45:38, ivo welch wrote:
> I am not a kernel developer, so forgive the intrusion.

Good bug reports are always welcome.

> I suspect I have found either a bug in gdb (less likely) or a bug in
> fanotify (more likely).  it is replicable, and the code is almost
> unchanged from the example in the fanotify man page.  to trigger it,
> all an su needs to do is to step through the program below with gdb
> 7.8.1 'n' command, and linux locks up the system pretty hard (reboot

Hard lockup -> this can't be gdb problem.

> required).  I have confirmed the replicability of this issue on a
> clean arch 2014.12.01 3.17.6-1 system and on a clean ubuntu 14.10
> system, both VMs created just to check it.  /iaw

Does it need root priviledges to trigger?

Best regards,
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
