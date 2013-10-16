Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab3JPHaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:30:21 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:18274 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317Ab3JPHaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:30:20 -0400
Date: Wed, 16 Oct 2013 09:29:58 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>
Message-ID: <20131016072958.GD4285@enneenne.com>
Mail-Followup-To: Paul Chavent <Paul.Chavent@onera.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Alexander Gordeev <agordeev@redhat.com>
References: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
 <20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>
 <20131015104350.GI4285@enneenne.com>
 <20131015125545.1920ab5453136f3de5f2aa66@linux-foundation.org>
 <525E37BF.4040303@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525E37BF.4040303@onera.fr>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.10
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on goldrake.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 08:52:47AM +0200, Paul Chavent wrote:
> 
> I would also prefer the separate ioctl. As you said it, it's a bit
> annoying to switch from blocking mode to non blocking mode if we
> need both mode. But i was not sure about the preferences of the
> maintainer : (i) change the api, or (ii) change the behavior with a
> widely supported interface (O_NONBLOCK).

As already stated the PPS RFC doesn't use ioctls to manage PPS data so
we can modify ioctls according our needs!

In fact we can modify the LinuxPPS wrapper functions to still remain
RFC compliant. :)

> I'm certainly not the best person to make the final decision, but i
> would like to help you if you need me (write doc, or change this
> patch).

In this scenario I think we can do as Andrew suggests modifying
LinuxPPS docs accordingly... maybe we can add a new file into
linux/Documentation/pps directory describing Linux PPS ioctls and how
they interact with PPS RFC functions.

Andrew, could this be an acceptable solution?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
