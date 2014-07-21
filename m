Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaGUIbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:31:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbaGUIbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:31:21 -0400
Date: Mon, 21 Jul 2014 10:32:02 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: bitmap tag: fix potential unwakeable sleep in
 bt_get()
Message-ID: <20140721083202.GA2107@dhcp-26-207.brq.redhat.com>
References: <1405930246-2051-1-git-send-email-agordeev@redhat.com>
 <53CCCC76.7060506@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CCCC76.7060506@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:16:54AM +0200, Jens Axboe wrote:
> What is this patch against?

v3.16-rc5

> -- 
> Jens Axboe
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
