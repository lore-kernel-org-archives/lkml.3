Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaJQTTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbaJQTTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:19:10 -0400
Date: Fri, 17 Oct 2014 21:15:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 0/2] (Was: kernel/kmod: fix use-after-free of the
	sub_infostructure)
Message-ID: <20141017191557.GA22270@redhat.com>
References: <20141016160042.7f898871@mschwide> <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp> <20141016174209.GB18318@redhat.com> <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp> <20141016215834.GA28864@redhat.com> <20141017093653.6fa60dff@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017093653.6fa60dff@mschwide>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Martin Schwidefsky wrote:
>
> Version 2 of the patch.

On top of this patch.

Tetsuo, can you review?

Oleg.

 kernel/kmod.c |   43 +++++--------------------------------------
 1 files changed, 5 insertions(+), 38 deletions(-)

