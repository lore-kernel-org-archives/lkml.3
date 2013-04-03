Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3DCBOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:14:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42795 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab3DCBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:14:31 -0400
Date: Wed, 3 Apr 2013 02:14:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20130403011430.GL21522@ZenIV.linux.org.uk>
References: <20130403112235.0ec96e6e03389a791ad6b959@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403112235.0ec96e6e03389a791ad6b959@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 11:22:35AM +1100, Stephen Rothwell wrote:
> And many, many more.
> 
> Caused by commit 1f4fbcb8700c ("create_proc_cpu_mask() doesn't need an
> argument...").  Please build test this stuff *before* publishing it.  :-(

"Remember to push the fixes", actually ;-/
