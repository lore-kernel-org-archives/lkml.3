Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3LSSN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:13:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3LSSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:13:55 -0500
Date: Thu, 19 Dec 2013 10:13:57 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v2] drivers: base: Add prototype declaration to the
 header file
Message-ID: <20131219181357.GA27658@kroah.com>
References: <20131218063953.GA3180@rashika>
 <1387452297-28836-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387452297-28836-1-git-send-email-rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:54:57PM +0530, Rashika Kheria wrote:
> Add prototype declaration of function memory_block_size_bytes() to
> the header file include/linux/memory.h.
> 
> This eliminates the following warning in memory.c:
> drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Please ALWAYS run your patches through checkpatch.pl so a maintainer
doesn't have to write you an email like this reminding you to do that...

Josh, come on, you should have caught this as well, fix up your email
client to flag stuff like this easier...

greg k-h
