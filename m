Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaDSQP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:15:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56313 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaDSQPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:15:54 -0400
Date: Sat, 19 Apr 2014 18:15:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>, jikos@jikos.cz
Subject: Re: [RFC] Only a.out QMAGIC format is working
Message-ID: <20140419161552.GB27776@amd.pavel.ucw.cz>
References: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I was researching about old binary formats and did some tests.
> Meantime, I was able to run sucessfully only the QMAGIC format.
> Nonetheless, the OMAGIC, NMAGIC and ZMAGIC didn't work anymore.

Some time ago, I ran into similar problem, and turning off userspace
randomization was neccessary... Jiri Kosina might remember details.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
