Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaAVETR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:19:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44951 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAVETQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:19:16 -0500
Date: Tue, 21 Jan 2014 20:19:13 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
Message-ID: <20140122041913.GE20347@kernel.dk>
References: <alpine.LNX.2.00.1401171455060.23018@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401171455060.23018@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17 2014, Jiri Kosina wrote:
> Jens,
> 
> please consider pulling
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens
> 
> into your for-3.14/drivers branch to receive
> 
> Jiri Kosina (1):
>       floppy: bail out in open() if drive is not responding to block0 read

Thanks Jiri, pulled.

-- 
Jens Axboe

