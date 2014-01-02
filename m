Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaABTi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:38:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaABTi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:38:57 -0500
Date: Thu, 2 Jan 2014 14:38:47 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Karl Dahlke <eklhad@comcast.net>
Subject: Re: [PATCH 3.12 v2] Broken terminal due to echo bufferring
In-Reply-To: <20131218235310.GC14527@kroah.com>
Message-ID: <alpine.LRH.2.02.1401021438310.832@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312091004110.19590@file01.intranet.prod.int.rdu2.redhat.com> <20131218235310.GC14527@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Dec 2013, Greg Kroah-Hartman wrote:

> On Mon, Dec 09, 2013 at 10:10:50AM -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm sending another version of the patch that removes some unneeded 
> > code for echo bufferring - 41 lines are removed.
> 
> This should now all be resolved in Linus's tree, and this patch is not
> needed, right?

You don't need this patch if you backported 
1075a6e2dc7e2a96efc417b98dd98f57fdae985d.

Mikulas

> thanks,
> 
> greg k-h
> 
