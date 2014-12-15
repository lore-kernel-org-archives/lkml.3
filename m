Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaLOVLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:11:20 -0500
Received: from syn.loicp.eu ([176.31.96.212]:34694 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaLOVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:11:19 -0500
Date: Mon, 15 Dec 2014 22:11:15 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update CONFIG_DM_CRYPT help-text link
Message-ID: <20141215211114.GA1388@iron>
References: <81c1a7329d2146d37b22d7efa96b3a449cb66d14.1418674665.git.loic@loicp.eu>
 <20141216073037.75ec447b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141216073037.75ec447b@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 07:30:37AM +1100, NeilBrown wrote:
> 
> Please direct this according to:
> 
> DEVICE-MAPPER  (LVM)
> M:	Alasdair Kergon <agk@redhat.com>
> M:	Mike Snitzer <snitzer@redhat.com>
> M:	dm-devel@redhat.com
> L:	dm-devel@redhat.com
> W:	http://sources.redhat.com/dm
> Q:	http://patchwork.kernel.org/project/dm-devel/list/
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> T:	quilt http://people.redhat.com/agk/patches/linux/editing/
> S:	Maintained
> F:	Documentation/device-mapper/
> F:	drivers/md/dm*
> F:	drivers/md/persistent-data/
> F:	include/linux/device-mapper.h
> F:	include/linux/dm-*.h
> F:	include/uapi/linux/dm-*.h
> 
> I guess get-maintainer.pl doesn't cope when when on file has separate parts
> which are separately maintained.
> 
> Thanks,
> NeilBrown

I will do that, thanks for the info!

-- 
Cheers,
Loïc

