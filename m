Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbbA0SBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:01:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbbA0SBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:01:00 -0500
Date: Tue, 27 Jan 2015 10:01:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] gpio: sysfs: backports of memleak fixes to 3.12
Message-ID: <20150127180100.GA20901@kroah.com>
References: <1422295496-6194-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422295496-6194-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 07:04:54PM +0100, Johan Hovold wrote:
> Hi Greg,
> 
> Here are backports of two fixes for memory leaks in the gpio sysfs
> interface that are needed in the stable trees.
> 
> Tested on 3.12, but will not compile on 3.10 or earlier which lacks
> device_create_with_groups. I'll send a second version for these kernels.

Thanks for all of these, now applied.

greg k-h
