Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaBUXm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:42:58 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58595 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaBUXm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:42:57 -0500
Date: Fri, 21 Feb 2014 15:42:53 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drbd: Fix future possible NULL pointer dereference
Message-ID: <20140221234253.GD29129@kernel.dk>
References: <20140218202054.GD25515@kernel.dk>
 <1392803347-6075-1-git-send-email-philipp.reisner@linbit.com>
 <1392803347-6075-2-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392803347-6075-2-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19 2014, Philipp Reisner wrote:
> From: Andreas Gruenbacher <agruen@linbit.com>
> 
> Right now every resource has exactly one connection. But we are preparing
> for dynamic connections. I.e. in the future thre can be resources without
> connections.
> 
> However smatch points this out as 'variable dereferenced before check',
> which is correct.
> 
> This issue was introduced in
> drbd: get_one_status(): Iterate over resource->devices instead of connection->peer_devices

Applied, thanks.

-- 
Jens Axboe

