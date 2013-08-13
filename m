Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3HMFvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:51:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3HMFvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:51:38 -0400
Date: Mon, 12 Aug 2013 22:53:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Joshua C." <joshuacov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Patch "drm/radeon: never unpin UVD bo v3" has been added to the
 3.10-stable tree
Message-ID: <20130813055303.GD22700@kroah.com>
References: <CAKL7Q7r3321J-O6A-m=VY1eH+R11SRE6WnJHCFC=nE7TZxkRug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKL7Q7r3321J-O6A-m=VY1eH+R11SRE6WnJHCFC=nE7TZxkRug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 03:44:14PM +0200, Joshua C. wrote:
> I have an open bug again the aforementioned patch:
> https://bugs.freedesktop.org/show_bug.cgi?id=67276 . Can you, please,
> hold the patch, untill the bug is resolved?

Please work with the upstream developers to resolve the bug, then the
make sure the fix is also tagged for the stable tree.

thanks,

greg k-h
