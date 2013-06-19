Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307Ab3FSLLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:11:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33176 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991Ab3FSLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:11:43 -0400
Date: Wed, 19 Jun 2013 13:11:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [uio 1/2] fix uio_pdrv_genirq with device tree but no interrupt
Message-ID: <20130619111140.GA20356@amd.pavel.ucw.cz>
References: <20130618203453.GA18503@amd.pavel.ucw.cz>
 <20130618224404.GA32230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618224404.GA32230@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-06-18 15:44:04, Greg KH wrote:
> What's with the odd [uio] in the Subject?  What happened to the
> universal [PATCH 1/2] format?
> 
> Ick, I'll fix this up this time, but come on, you know better...

Sorry about that. It seems every maintainer has slightly different
rules for that... I thought that stuff in [] is normally ignored, so I
did not give it too much thought.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
