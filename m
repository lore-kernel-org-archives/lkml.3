Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaIVOf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:35:56 -0400
Received: from verein.lst.de ([213.95.11.211]:47804 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaIVOfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:35:54 -0400
Date: Mon, 22 Sep 2014 16:35:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140922143550.GA2768@lst.de>
References: <20140919165817.225eb8b8@canb.auug.org.au> <20140919202410.GA26329@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919202410.GA26329@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Trond commited the fix for this yesterday.  If this error doesn't disappear
from the next linux-next build that contains:

"pnfs/blocklayout: Fix a 64-bit division/remainder issue in bl_map_stripe"

please contact me as we might have another problem in that case.

