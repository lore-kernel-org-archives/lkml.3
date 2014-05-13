Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaEMTG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaEMTGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:06:47 -0400
Date: Tue, 13 May 2014 21:06:35 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140513190634.GC2738@mguzik.redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <1400006371.24350.45.camel@joe-AO725>
 <20140513185312.GB2738@mguzik.redhat.com>
 <1400007621.24350.47.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400007621.24350.47.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:00:21PM -0700, Joe Perches wrote:
> On Tue, 2014-05-13 at 20:53 +0200, Mateusz Guzik wrote:
> > This is the same code which you can find at the end of the function.
> > I added the label so that I can write freeze printk only once.
> 
> Yes, but for a read-only filesystem is the message useful?
> 

I see no harm in printing it and it seems more correct given that
s_writers.frozen changed, but I'm fine either way.

btw, I just noticed a copy-pasto - the same message for freezing and
unfreezing found its way into the patch. sigh.
-- 
Mateusz Guzik
