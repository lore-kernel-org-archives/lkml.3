Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaKUUGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:06:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48823 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaKUUGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:06:24 -0500
Date: Fri, 21 Nov 2014 21:06:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: AL13N <alien@rmail.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory leaks on atom-based boards?
Message-ID: <20141121200622.GB26833@amd>
References: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-27 18:44:03, AL13N wrote:
> I have several machines with the same OS and kernel (3.14.22).
> 
> 2 of those machines are both atom-based boards and they get OOM, without
> swap being used (MemAvail crawls down towards 0, even though not more
> memory is used on processes).
> 
> Specifically, this one machine, i need to reboot every 3 à 5 days.

Run the machine without swap and with mem=512M (or something), and it
will reproduce sooner....

You may want to recompile kernel (or something similar) to give leak a
chance...

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
