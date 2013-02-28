Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890Ab3B1WOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:14:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3B1WOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:14:45 -0500
Date: Thu, 28 Feb 2013 14:14:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] mm: tuning hardcoded reserved memory
Message-Id: <20130228141441.7dbd19be.akpm@linux-foundation.org>
In-Reply-To: <20130227210925.GB8429@localhost.localdomain>
References: <20130227210925.GB8429@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013 16:09:25 -0500
Andrew Shewmaker <agshew@gmail.com> wrote:

> Add a rootuser_reserve_pages knob to allow admins of large memory 
> systems running with overcommit disabled to change the hardcoded 
> memory reserve to something other than 3%.
> 
> Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
> 
> ---
> 
> Patch based off of mmotm git tree as of February 27th.
> 
> I set rootuser_reserve pages to be a default of 1000, and I suppose 
> I should have initialzed similarly to the way min_free_kbytes is, 
> scaling it with the size of the box. However, I wanted to get a 
> simple version of this patch out for feedback to see if it has any 
> chance of acceptance or if I need to take an entirely different 
> approach.
> 
> Any feedback will be appreciated!

Seems reasonable.

Yes, we should scale the initial value according to the machine size in
some fashion.

btw, both these patches had the same title.  Please avoid this.
Documentation/SubmittingPatches section 15 has all the details.

