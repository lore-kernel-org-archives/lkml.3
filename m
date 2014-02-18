Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBRUSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:18:14 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34099 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaBRUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:18:11 -0500
Date: Tue, 18 Feb 2014 12:18:07 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bio: don't write "bio: create slab" messages to syslog
Message-ID: <20140218201807.GB25515@kernel.dk>
References: <alpine.LRH.2.02.1402181307200.30436@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402181307200.30436@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18 2014, Mikulas Patocka wrote:
> When using device mapper, there are many "bio: create slab" messages in
> the log. Device mapper targets have different front_pad, so each time when
> we load a target that wasn't loaded before, we allocate a slab with the
> appropriate front_pad and there is associated "bio: create slab" message.
> 
> This patch removes these messages, there is no need for them.

Agreed, it's time to kill off that message. Applied, thanks.

-- 
Jens Axboe

