Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaDHHKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:10:50 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55600 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:10:48 -0400
Date: Tue, 8 Apr 2014 11:10:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com, tglx@linutronix.de,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com
Subject: Re: [patch 1/3] timerfd: Implement show_fdinfo method
Message-ID: <20140408071042.GE23983@moon>
References: <20140407174701.734703531@openvz.org>
 <20140407174933.641611536@openvz.org>
 <5343946A.6000601@parallels.com>
 <20140408064223.GD23983@moon>
 <53439D35.3050201@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53439D35.3050201@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:54:45AM +0400, Vladimir Davydov wrote:
> > Hi Vladimir! Well it_value returns remaining time so it's up to user to
> > adjust this value when restore with abs time. That said one can examinate
> > if abs flag was set and restore accordingly. If this is vague I'm open
> > to change it to more clear way. Ideas?
> 
> If it's intended, it should be documented explicitly I think. Currently
> in the doc patch I see nothing about whether expiration time is absolute
> or relative:
> 
> > 'it_value' and 'it_interval' are the expiration time and interval for the timer.

I'll update, thanks!
