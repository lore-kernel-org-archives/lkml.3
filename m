Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3JXJ0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JXJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:13 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: 
Date: Thu, 24 Oct 2013 10:25:53 +0100
Message-Id: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been working (on and off) on blk-mq for a while now, and
I think it's finally time to polish it off and get it posted
for review with inclusion for 3.13. It's fairly well contained
and these core bits should not impact any drivers. There's
a series of prep patches in front of the meat patch.

You can also find this series here:

git://git.kernel.dk/linux-block.git blk-mq/core

and there's a separate repo with some driver updates here:

git://git.kernel.dk/linux-block.git blk-mq/drivers

which is layered on top of the core bits.

See patch 10 for a description of blk-mq itself and the
reasoning behind this new queueing model. There's also been
a paper published on results run on the code last year. Note that
this is somewhat out of date as the code has moved along since,
most notably it should be much faster now. The paper can be found
here:

http://kernel.dk/systor13-final18.pdf

and was presented at Systor 2013 earlier this year.

