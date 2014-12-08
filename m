Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaLHA6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 19:58:35 -0500
Received: from 1wt.eu ([62.212.114.60]:48575 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbaLHA6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 19:58:34 -0500
Date: Mon, 8 Dec 2014 01:58:32 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [ 00/25] 2.6.32.65-longterm review
Message-ID: <20141208005832.GA26238@1wt.eu>
References: <2a26e912d2438674771c36169c190830@local> <20141206174148.394089034@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206174148.394089034@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 06:41:48PM +0100, Willy Tarreau wrote:
> This is the start of the longterm review cycle for the 2.6.32.65 release.
> All patches will be posted as a response to this one. If anyone has any
> issue with these being applied, please let me know. If anyone is a
> maintainer of the proper subsystem, and wants to add a Signed-off-by: line
> to the patch, please respond with it.
> 
> Responses should be made by Fri Dec 12 12:00:00 CET 2014.
> Anything received after that time might be too late. If someone
> wants a bit more time for a deeper review, please let me know.
> 
> The whole patch series can be found in one patch at :
>      kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.65-rc1.gz

Ben offered some patches for regressions or missing fixes in latest
versions so I've just included them and uploaded 2.6.32.65-rc2 there :

  kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.65-rc2.gz

The deadline has not changed. Shortlog below.

Thanks,
Willy

===============

Ben Hutchings (4):
      cciss: Fix misapplied "cciss: fix info leak in cciss_ioctl32_passthru()"
      proc connector: Delete spurious memset in proc_exit_connector()
      sctp: Fix double-free introduced by bad backport in 2.6.32.62
      md/raid6: Fix misapplied backport in 2.6.32.64

Matthijs Kooijman (1):
      vlan: Don't propagate flag changes on down interfaces.

Muthukumar Ratty (1):
      block: Fix blk_execute_rq_nowait() dead queue handling

Tejun Heo (1):
      block: add missing blk_queue_dead() checks

