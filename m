Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3GVGd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3GVGdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:33:55 -0400
Date: Mon, 22 Jul 2013 12:03:41 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH V3 0/2] [BUGFIX] virtio/console: Fix two bugs of
 splice_write
Message-ID: <20130722063341.GA1806@amit-x200.redhat.com>
References: <20130722040043.7531.78801.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722040043.7531.78801.stgit@yunodevel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 22 Jul 2013 [13:00:43], Yoshihiro YUNOMAE wrote:
> Hi,
> 
> This patch set fixes two bugs of splice_write in the virtio-console driver.
> 
> [BUG1] Although pipe->nrbufs is empty, the driver tries to do splice_write.
>        => This induces oops in sg_init_table().
> 
> [BUG2] No lock for competition of splice_write.
>        => This induces oops in splice_from_pipe_feed() by bug of any user
>           application.
> 
> These reports are written in each patch.
> 
> Changes in V2:
> - Fix a locking problem for error
> 
> Changes in V3:
> - Add Reviewed-by lines and stable@ line in sign-off area

Thank you!

Rusty, please pick this up.

		Amit
