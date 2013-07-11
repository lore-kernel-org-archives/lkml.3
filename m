Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3GKLi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:38:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40804 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3GKLiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:38:24 -0400
Date: Thu, 11 Jul 2013 13:38:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Galeck <mark_galeck@pacbell.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: is it desirable to improve the build system?
Message-ID: <20130711113822.GA18579@amd.pavel.ucw.cz>
References: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> Does the Linux-Kernel Community perceive that is the case?
> 
> If so, do you think it is possible to improve?
> 
> If so, would such an attempt be welcome, including and especially by, the current maintainer(s) of the build?  Of course it would have to be completely backwards-compatible, including to the text output interface and requirements for modules makefiles.
> 

Yes, speeding up build would be nice. Especially nice would be
speeding up "empty" build, when only one or two files changed...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
