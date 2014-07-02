Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaGBIYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:24:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaGBIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:24:14 -0400
Date: Wed, 2 Jul 2014 01:24:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
Cc: linux-kernel@vger.kernel.org,
        Thomas =?iso-8859-1?Q?Sch=F6bel-Theuer?= <tst@1und1.de>
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140702082400.GB10971@kroah.com>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
 <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
 <20140701223644.GA30330@kroah.com>
 <53B3B283.7050800@schoebel-theuer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3B283.7050800@schoebel-theuer.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Jul 02, 2014 at 09:19:31AM +0200, Thomas Schoebel-Theuer wrote:
> I will prepare a new version ASAP.
> 
> Is the asmlinkage one of the reasons?

No.  The wholesale exporting of all 300+ syscall functions for no
apparent reasoning is the reason.

> If so, some additional wrappers like vfs_* or kernel_* would have to be
> written. This would also complicate portability between the out-of-tree
> and the in-tree version of MARS (which I have to maintain in parallel at
> least for some years).

Maintaining out of tree code is not our problem, sorry.

thanks,

greg k-h
