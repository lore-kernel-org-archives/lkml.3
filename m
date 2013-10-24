Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3JXKbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:31:46 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:50586 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3JXKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:31:45 -0400
Date: Thu, 24 Oct 2013 11:31:38 +0100
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@karo-electronics.de>
Subject: Re: [PATCH next] sysfs: fix sysfs_write_file for bin file
Message-ID: <20131024103138.GA13159@mtj.dyndns.org>
References: <1382535893-20543-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382535893-20543-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:44:53PM +0800, Ming Lei wrote:
> Before patch(sysfs: prepare path write for unified regular / bin
> file handling), when size of bin file is zero, writting still can
> continue, but this patch changes the behaviour.
> 
> The worse thing is that firmware loader is broken by this patch,
> and user space application can't write to firmware bin file any more
> because both firmware loader and drivers can't know at advance how
> large the firmware file is and have to set its initialized size as
> zero.
> 
> This patch fixes the problem and keeps behaviour of writting to bin
> as before.
> 
> Reported-and-tested-by: Lothar Waﬂmann <LW@karo-electronics.de>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Oops, sorry about missing that.

  Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
