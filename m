Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3CVO5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:57:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34822 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab3CVO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:57:51 -0400
Date: Fri, 22 Mar 2013 08:57:41 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.9
Message-ID: <20130322145741.GG25978@kernel.dk>
References: <20130320212753.GA15060@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320212753.GA15060@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20 2013, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.9
> 
> which has a bunch of fixes. They vary from being able to deal with unknown
> requests, overflow in statistics, compile warnings, bug in the error path,
> removal of unnecessary logic. There is also one performance fix - which is
> to allocate pages for requests when the driver loads - instead of doing it
> per request.

Pulled, thanks Konrad.

-- 
Jens Axboe

