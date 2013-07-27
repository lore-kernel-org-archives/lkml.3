Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445Ab3G0A6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 20:58:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab3G0A6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 20:58:11 -0400
Date: Fri, 26 Jul 2013 17:58:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] uio: provide vm access to UIO_MEM_PHYS maps
Message-ID: <20130727005810.GA16817@kroah.com>
References: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1373995264-31448-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373995264-31448-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 07:21:03PM +0200, Uwe Kleine-König wrote:
> This makes it possible to let gdb access mappings of the process that is
> being debugged.
> 
> uio_mmap_logical was moved and uio_vm_ops renamed to group related code
> and differentiate to new stuff.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This patch breaks the build:

drivers/uio/uio.c: In function ‘uio_mmap_logical’:
drivers/uio/uio.c:627:17: error: ‘uio_vm_ops’ undeclared (first use in this function)

:(
