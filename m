Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3CaPrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 11:47:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3CaPra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 11:47:30 -0400
Date: Sun, 31 Mar 2013 17:47:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove obsolete, iSeries specific, Makefile
 lines
In-Reply-To: <1364568500.1345.78.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1303311746490.22069@pobox.suse.cz>
References: <1364568500.1345.78.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Entirely untested.
> 
> 1) See commit 3d066d77cf464ea1e47808f95243301fd2175a7f ("powerpc: remove
> CONFIG_PPC_ISERIES from the architecture Kconfig files") and commit
> ba7a4822b48fbc7afd6b567c18e316a03f46684d ("powerpc: Remove some of the
> legacy iSeries specific device drivers").

I believe you could remove all the corresponding major number defines from 
include/uapi/linux/major.h while you are at it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
