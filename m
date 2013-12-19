Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3LSCl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:41:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3LSCkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:40:20 -0500
Date: Wed, 18 Dec 2013 16:57:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: xqx12 <s2exqx@gmail.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, chyyuu@gmail.com,
        xuyongjiande@gmail.com, xqx12 <xiaoqixue_1@163.com>
Subject: Re: [PATCH] tty: an overflow of multiplication in
 drivers/tty/cyclades.c
Message-ID: <20131219005740.GA6257@kroah.com>
References: <1387328429-15172-1-git-send-email-xiaoqixue_1@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387328429-15172-1-git-send-email-xiaoqixue_1@163.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 09:00:29AM +0800, xqx12 wrote:
> there is an overflow in the code :
> cyz_polling_cycle = (arg * HZ) / 1000,
> the multiplicator arg comes from user, so it may be an overflow if
> arg is a big number. And the value of cyc_polling_cycle will be
> wrong when it is used next time.
> 
> Reported-by: Qixue Xiao <xiaoqixue_1@163.com>
> Suggested-by: Yongjian Xu <xuyongjiande@gmail.com>
> Suggested-by: Yu Chen <chyyuu@gmail.com>
> Signed-off-by: Qixue Xiao <xiaoqixue_1@163.com>

I need a "real" name as the "From:" line here, especially as it doesn't
match any of these lines either :(

