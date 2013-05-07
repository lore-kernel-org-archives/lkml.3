Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3EGRXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:23:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3EGRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:23:05 -0400
Date: Tue, 7 May 2013 10:23:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 067/115] ARM: 7702/1: Set the page table freeing ceiling to
 TASK_SIZE
Message-ID: <20130507172304.GA30765@kroah.com>
References: <20130506203055.537199268@linuxfoundation.org>
 <20130506203102.410919957@linuxfoundation.org>
 <alpine.LNX.2.00.1305061628480.4387@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305061628480.4387@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:00:39PM -0700, Hugh Dickins wrote:
> On Mon, 6 May 2013, Greg Kroah-Hartman wrote:
> 
> > 3.9-stable review patch.  If anyone has any objections, please let me know.
> 
> NAK to 067/115 for 3.9, 063/104 for 3.8 and 38/63 for 3.4: they duplicate
>        036/115 for 3.9, 034/104 for 3.8 and 16/63 for 3.4.
> 
> Commit 6aaa189f8712471a250bfdf8fc8d08277258b8ab upstream is a duplicate of
> commit 104ad3b32d7a71941c8ab2dee78eea38e8a23309 upstream; but whereas git
> resolves the duplication in Linus's tree, they show up as a repeated
> definition block in patch-3.9.1-rc1.

Ah, good catch, thanks, I'll go drop this patch from those trees, thanks
for letting me know.

greg k-h
