Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3GBGex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:34:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3GBGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:34:52 -0400
Date: Tue, 2 Jul 2013 08:34:49 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [GIT PULL] Bcache changes for 3.11
Message-ID: <20130702063449.GO32428@kernel.dk>
References: <20130701221000.GA4794@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701221000.GA4794@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01 2013, Kent Overstreet wrote:
> Hi Jens, here's the bcache changes for 3.11.
> 
> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
> 
>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

Ugh, that is 6 rcs ahead of where my for-3.11/drivers branch is sitting.
I guess there's no real way to avoid fast forwarding a bit, since there
are bcache fixes in that range as well.

-- 
Jens Axboe

