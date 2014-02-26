Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaBZRgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:36:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57776 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaBZRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:36:44 -0500
Date: Wed, 26 Feb 2014 09:36:40 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-atm-general@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] sleep_on removal, second try
Message-ID: <20140226173640.GA11990@kernel.dk>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26 2014, Arnd Bergmann wrote:
> It's been a while since the first submission of these patches,
> but a lot of them have made it into linux-next already, so here
> is the stuff that is not merged yet, hopefully addressing all
> the comments.
> 
> Geert and Michael: the I was expecting the ataflop and atari_scsi
> patches to be merged already, based on earlier discussion.
> Can you apply them to the linux-m68k tree, or do you prefer
> them to go through the scsi and block maintainers?
> 
> Jens: I did not get any comments for the DAC960 and swim3 patches,
> I assume they are good to go in. Please merge.

Picked up 1, 3, 4 of the patches. Thanks Arnd.

-- 
Jens Axboe

