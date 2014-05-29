Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaE2GnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:43:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:46363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaE2GnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:43:05 -0400
Date: Thu, 29 May 2014 08:43:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/1] rename {before/after}_atomic_{inc/dec} to
 {before/after}_atomic
Message-ID: <20140529064302.GG19143@laptop.programming.kicks-ass.net>
References: <5386B75A.3010806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386B75A.3010806@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:28:10AM -0400, Pranith Kumar wrote:
>  There is no reason to have separete barriers for atomic_inc and atomic_dec. 
>  All the architectures use the same barriers for both.
> 
>  We can simplify it and just have {before/after}_atomic after renaming.
> 
>  I used coccinelle script to do the renames in the C files and did the rename by hand in the headers.
> 
> v2: 
> * remove duplicate macros in missed files
> * correct indentation
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

See http://marc.info/?l=linux-kernel&m=139782635207358 and the 20 or so
patches afterwards.

This has already been done. See a -next tree or so near you.
