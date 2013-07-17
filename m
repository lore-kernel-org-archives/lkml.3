Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3GQDLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 23:11:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53742 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3GQDLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 23:11:08 -0400
Date: Tue, 16 Jul 2013 21:11:05 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [GIT PULL] Bcache fixes for 3.11
Message-ID: <20130717031105.GW22392@kernel.dk>
References: <20130716211221.GD27000@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716211221.GD27000@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16 2013, Kent Overstreet wrote:
> Hey Jens - I've been busy torture testing and chasing bugs, here's the
> fruits of my labors. These are all fairly small fixes, some of them
> quite important:
> 
> The following changes since commit 8e51e414a3c6d92ef2cc41720c67342a8e2c0bf7:
> 
>   bcache: Use standard utility code (2013-07-01 14:43:53 -0700)
> 
> are available in the git repository at:
> 
>   git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11
> 
> for you to fetch changes up to 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:
> 
>   bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)

Thanks Kent, pulled in for 3.11. Due to my recent move, the 3.11 drivers
pull is delayed a bit, will go out shortly.

-- 
Jens Axboe

