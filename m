Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3KOFqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:46:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3KOFqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:46:10 -0500
Date: Fri, 15 Nov 2013 13:17:30 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 07/40] staging/lustre/hsm: Implementation of exclusive
 open
Message-ID: <20131115041730.GA539@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-8-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384445622-12346-8-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:13:09AM +0800, Peng Tao wrote:
> From: Jinshan Xiong <jinshan.xiong@intel.com>
> 
> In this patch, a framework of lease is implemented. However,
> only exclusive lease is supported right now.

Which is a problem, why?

Why do you want to add this new functionality?  What is it good for?
Who will use it?

Oh, and the patch doesn't apply to my tree, AND it contains a bunch of
foolish coding style errors, so even if I did understand what this was
for, and why we wanted it, I couldn't.

Please be more careful, I'm really stopping here now on reviewing these
lustre patches.  Please clean them up, resync, and try again, I've now
purged them all from my mboxes, sorry.

greg k-h
