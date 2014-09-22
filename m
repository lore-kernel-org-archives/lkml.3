Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaIVOkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:40:49 -0400
Received: from verein.lst.de ([213.95.11.211]:47817 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbaIVOkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:40:18 -0400
Date: Mon, 22 Sep 2014 16:40:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140922144013.GB2768@lst.de>
References: <20140919165817.225eb8b8@canb.auug.org.au> <20140919200653.GA25785@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919200653.GA25785@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

I've pushed the patch from Avago to fix this issue to

  git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.18

James, can you pull it into your SCSI tree so it gets to Linux-next?

