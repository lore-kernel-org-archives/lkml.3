Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3LRXxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:53:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3LRXxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:53:09 -0500
Date: Wed, 18 Dec 2013 15:53:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Karl Dahlke <eklhad@comcast.net>
Subject: Re: [PATCH 3.12 v2] Broken terminal due to echo bufferring
Message-ID: <20131218235310.GC14527@kroah.com>
References: <alpine.LRH.2.02.1312091004110.19590@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1312091004110.19590@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:10:50AM -0500, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending another version of the patch that removes some unneeded 
> code for echo bufferring - 41 lines are removed.

This should now all be resolved in Linus's tree, and this patch is not
needed, right?

thanks,

greg k-h
