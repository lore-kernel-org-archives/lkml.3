Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3DBAjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:39:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40447 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3DBAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:39:15 -0400
Date: Tue, 2 Apr 2013 01:39:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20130402003914.GG21522@ZenIV.linux.org.uk>
References: <20130402112627.223048680be1397ad59cdcec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402112627.223048680be1397ad59cdcec@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:26:27AM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/kernel/lparcfg.c:44:31: error: 'proc_ppc64_lparcfg' defined but not used [-Werror=unused-variable]
> cc1: all warnings being treated as errors
> 
> Caused by commit dfda3a48f2e7 ("lparcfg: don't bother saving pointer to
> proc_dir_entry").
> 
> I have used the vfs tree form next-20130328 for today.

... or just remove the variable ;-)  Fixed and pushed.
