Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3KLMfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:35:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3KLMfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:35:02 -0500
Date: Tue, 12 Nov 2013 13:34:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jiang Liu <jiang.liu@huawei.com>, Toshi Kani <toshi.kani@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Suspend / Resume broken on Toshiba R830 / R700
Message-ID: <20131112123452.GB29317@amd.pavel.ucw.cz>
References: <CA+MoWDqEv0vxU3erx9GCuJAzK73U+WiuMwY71t94WB6HH-264A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDqEv0vxU3erx9GCuJAzK73U+WiuMwY71t94WB6HH-264A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have one Toshiba R830 and one R700 and suspend / resume is broken on
> both. I've filled a bug report[1] on 03/02/2012, and it is still not
> fixed.
> 
> It apparently suspend well and start resuming, but then something goes
> wrong, the screen keeps black and the CPU fan goes full speed.
> 
> I suspect that this affects a considerable large number of devices.
> 
> I'm looking for fixing it. Can anyone point me some directions?

Try with minimal kernel configuration, see if it works...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
