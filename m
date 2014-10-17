Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaJQJnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:43:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaJQJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:43:30 -0400
Date: Fri, 17 Oct 2014 02:43:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-api@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve Hj?nnev?g <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141017094329.GB18015@infradead.org>
References: <20141016124741.GA3832@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016124741.GA3832@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:47:41PM +0200, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The Android binder code has been "stable" for many years now.  No matter
> what comes in the future, we are going to have to support this API, so
> might as well move it to the "real" part of the kernel as there's no
> real work that needs to be done to the existing code.

NAK.  It's complete rubbish and does things to the FD code that it
really shouldn't.  Android needs to completely redo the interface, and
there's been absolutely no work towards that.

This is exactly the sort of attitude I feared about when you started the
whole staging concepts, and it sounds like a good reason to disband
staging entirely, given that it's been mostly useless except for
boasting peoples commit statistics.

