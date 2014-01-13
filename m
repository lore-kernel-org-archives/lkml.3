Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaAMXB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:01:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAMXBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:01:23 -0500
Date: Mon, 13 Jan 2014 15:02:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: hv: Trivial cleanups for drivers/hv/connection.c
Message-ID: <20140113230200.GA3482@kroah.com>
References: <20131231215236.GA18573@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131231215236.GA18573@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 10:52:37PM +0100, Pavel Machek wrote:
> __u32 is only useful for kernel-user interface, u32 should be enough
> for kernel. Formatting was very confusing around __get_free_pages().
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

This doesn't apply to my char-misc.git tree, care to redo it after
3.14-rc1 is out so that we can properly sync up?

thanks,

greg k-h
