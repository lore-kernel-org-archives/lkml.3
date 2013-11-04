Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3KDUMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:12:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40270 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3KDUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:12:33 -0500
Message-ID: <5277FFA1.6060001@kernel.dk>
Date: Mon, 04 Nov 2013 13:12:17 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [GIT PULL] bcache changes for 3.13
References: <20131104200747.GD27129@kmo>
In-Reply-To: <20131104200747.GD27129@kmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 01:07 PM, Kent Overstreet wrote:
> Hey Jens, sorry for being late with this - anyways, it's roughly the same set of
> patches you had queued up before plus a few minor fixes, but it's been rebased
> onto your for-3.13/core branch.

Merge window is a little later this time, and since it was already in
for the previous release, we can make it happen.

But can you please base it on for-3.13/drivers however? That's where I'd
like to pull in the driver bits, and if I pull this one, then things get
even more tangled since for-3.13/core is holding the blk-mq changes too.

-- 
Jens Axboe

