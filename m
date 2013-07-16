Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab3GPR6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:58:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab3GPR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:58:08 -0400
Date: Tue, 16 Jul 2013 10:25:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 0/2] Resend of two uio patches
Message-ID: <20130716172542.GA22093@kroah.com>
References: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 07:21:02PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> these two patches were already sent back in April but fell through the
> cracks. They are not really related, but send in a series because they
> fail to apply in reverse order.
> 
> Patch 1 is useful for debugging with gdb, patch 2 is a cleanup. Note
> that patch 2 is only compile-tested because I don't have an uio driver
> that uses a non-physical map.                                                                                                                         
> Best regards
> Uwe

Thanks, I'll go through these later this week.

greg k-h
