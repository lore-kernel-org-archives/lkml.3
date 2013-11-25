Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3KYUh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:37:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3KYUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:37:56 -0500
Date: Mon, 25 Nov 2013 12:37:55 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 1/2] staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic
Message-ID: <20131125203755.GA14140@kroah.com>
References: <1385044966-3572-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385044966-3572-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 10:42:45PM +0800, Peng Tao wrote:
> It was introduced due to a patch hunk when porting
> commit 20802057 (staging/lustre/ptlrpc: race in pinger).

This patch was in 3.12, so this needs to go to the stable tree for 3.12,
right?  It also needs to get into 3.13-final, so please tell me that
next time so I know where to apply it to.

thanks,

greg k-h
