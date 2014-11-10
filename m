Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaKJN0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:26:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaKJN0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:26:49 -0500
Date: Mon, 10 Nov 2014 14:26:39 +0100
From: Karel Zak <kzak@redhat.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/5] brd: Add getgeo to block ops for fdisk
Message-ID: <20141110132639.GN6880@x2.net.home>
References: <545A2D69.8090003@plexistor.com>
 <545A2FEA.3050101@plexistor.com>
 <20141107092313.GH6880@x2.net.home>
 <545F9CF7.6090306@plexistor.com>
 <20141110095403.GL6880@x2.net.home>
 <54609E56.3050403@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54609E56.3050403@plexistor.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 01:15:34PM +0200, Boaz Harrosh wrote:
> >> Command (m for help): n
> >> First sector (34-8158, default 40): 
> >> Last sector, +sectors or +size{K,M,G,T,P} (40-8158, default 8158): 1717
> >> Command (m for help): n
> >> First sector (34-8158, default 1720): 
> >> # NOTE 34-8158 again, only with gpt
> > 
> >  It seems like a fdisk bug, the gap between 34-40 is smaller than phy sector
> >  size.. I'll fix it, thanks!
> > 
> 
> Please note that the final output needs to be 1718-8158 not
> 40-8158. I was not sure if you noticed from your explanation above.

 Yes, I understand, fixed in util-linux master branch. 
 
 https://github.com/karelzak/util-linux/commit/4a4616b22e21f3c05030dc05d98016fcb15a2ee9

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
