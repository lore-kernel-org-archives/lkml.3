Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaF3Gqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:46:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbaF3Gq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:46:27 -0400
Date: Mon, 30 Jun 2014 12:16:03 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] virtio: console: remove unnecessary null test before
 debugfs_remove_recursive
Message-ID: <20140630064603.GA27557@grmbl.mre>
References: <1404031293-5678-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404031293-5678-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Sun) 29 Jun 2014 [10:41:33], Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required
> 
> Cc: Amit Shah <amit.shah@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Amit Shah <amit.shah@redhat.com>

Rusty, can you pick this up please?

Thanks,

		Amit
