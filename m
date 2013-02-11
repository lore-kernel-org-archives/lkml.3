Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3BKTh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:37:28 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:48271 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3BKThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:37:23 -0500
Date: Mon, 11 Feb 2013 11:37:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, tmac@hp.com, linuxram@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [stable request] fix stack overflow in
 __reserve_region_with_split
Message-ID: <20130211193719.GA28315@kroah.com>
References: <51191BBE.9080904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51191BBE.9080904@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 05:26:38PM +0100, Jiri Slaby wrote:
> Hi,
> 
> I think this one should go to stable:
> commit 4965f5667f36a95b41cda6638875bc992bd7d18b
> Author: T Makphaibulchoke <tmac@hp.com>
> Date:   Thu Oct 4 17:16:55 2012 -0700
> 
>     kernel/resource.c: fix stack overflow in __reserve_region_with_split()
> 
> To all up to 3.7 (exclusive).

Queued up for 3.0-stable and 3.4-stable trees, thanks.

greg k-h
