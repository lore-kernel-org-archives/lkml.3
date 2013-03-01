Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3CAV4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:56:13 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39325 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3CAV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:56:12 -0500
Date: Fri, 1 Mar 2013 13:56:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
Message-ID: <20130301215609.GA3261@kroah.com>
References: <20130301.164711.326215889038834651.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301.164711.326215889038834651.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 04:47:11PM -0500, David Miller wrote:
> 
> I'm getting these non-stop right when the hypervisor console registers
> on sparc64, and the machine won't boot up properly.  This is with
> Linus's current tree.
> 
> [511865.556835] console [ttyHV0] enabled
> [511865.564555] ------------[ cut here ]------------
> [511865.612410] WARNING: at drivers/tty/tty_buffer.c:428 process_one_work+0x164/0x420()
> [511865.627846] tty is NULL

Sorry about this, I have a patch, from Jiri, to get to Linus after
3.9-rc1 to remove the warning.  It's safe to ignore.  Maybe I should
just push it today, I wasn't aware that it was being hit so easily.

thanks,

greg k-h
