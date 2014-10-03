Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaJCJKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:10:15 -0400
Received: from smtp.eu.citrix.com ([185.25.65.24]:5768 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJCJKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:10:07 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 05:10:07 EDT
X-IronPort-AV: E=Sophos;i="5.04,645,1406592000"; 
   d="scan'208";a="25662741"
From: Thanos Makatos <thanos.makatos@citrix.com>
To: "'Dave Chinner'" <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "jlayton@poochiereds.net" <jlayton@poochiereds.net>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "jack@suse.cz" <jack@suse.cz>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Topic: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Index: AQHP3ltJMeutIaA2t0eKb6z3ckY5/ZwdGI8AgACer4CAAFy2IA==
Date: Fri, 3 Oct 2014 09:00:14 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC0423DEE4@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk> <20141003052737.GL24490@dastard>
In-Reply-To: <20141003052737.GL24490@dastard>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: AMS1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This patch introduces a new ioctl called BLKFLUSHBUFS2, which is
> > > pretty
> 
> What a horrible name. Whatever happened to naming ioctls interfaces after
> their function? i.e. BLKFLUSHINVAL?

Indeed it's not a good name, I'm open to suggestions!
