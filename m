Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaKTQCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:02:55 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41001 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaKTQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:02:54 -0500
Date: Thu, 20 Nov 2014 11:02:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 04/10] writeback: move backing_dev_info->wb_lock and
 ->worklist into bdi_writeback
Message-ID: <20141120160249.GH14877@htj.dyndns.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <1416299848-22112-5-git-send-email-tj@kernel.org>
 <20141120160128.GI2330@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120160128.GI2330@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:01:28PM +0100, Jan Kara wrote:
...
>   Does this mean you want to have per-device, per-cgroup flusher workqueues?
> Otherwise this change doesn't make sense...

Not workqueues but yes separate work items per device-cgroup combo.
There's no way around it.

Thanks.

-- 
tejun
